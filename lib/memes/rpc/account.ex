defmodule Memes.Rpc.Account do
  import Ecto.Query, only: [where: 2, update: 2, select: 2]
  import Comeonin.Pbkdf2, only: [hashpwsalt: 1]
  import Memes.Rpc.Utils
  import Memes.Utils
  alias Memes.Repo

  def register(username, password, email)
      when is_binary(username) and is_binary(password) and is_binary(email) do
    validate_username!(username)
    validate_password!(password)
    validate_email!(email)
    name_available!(username)

    add_new_user(username, password, email)
    ok()
  end

  def login(username, password) when is_binary(username) and is_binary(password) do
    case check_pass(username, password) do
      true -> username |> Memes.AuthToken.issue |> ok
      _ -> error("Invalid username or password")
    end
  end

  def info(username) when is_binary(username) do
    username
    |> user_profile()
    |> select([:name, :bio, :icon, :username])
    |> Repo.all()
    |> case do
      [] -> error("User not found")
      [info] -> ok(info)
    end
  end

  def priv_info(token) when is_binary(token) do
    [email] =
      token
      |> login_as!
      |> user_account
      |> select([:email])
      |> Repo.all()

    ok(email)
  end

  def change_password(token, old_pass, new_pass) when is_binary(token) and
      is_binary(old_pass) and is_binary(new_pass) do
    hash = hashpwsalt(new_pass)

    token
    |> login_as!()
    |> check_pass!(old_pass)
    |> user_account
    |> update(set: [password_hash: ^hash])
    |> Repo.update_all([])
    ok()
  end

  def change_email(token, email) when is_binary(token) and is_binary(email) do
    username = login_as!(token)
    validate_email!(email)

    username
    |> user_account
    |> update(set: [email: ^email])
    |> Repo.update_all([])
    ok()
  end

  def change_name(token, name) when is_binary(token) and is_binary(name) do
    username = login_as!(token)
    validate_name!(name)

    username
    |> user_profile
    |> update(set: [name: ^name])
    |> Repo.update_all([])
    ok()
  end

  def change_bio(token, bio) when is_binary(token) and is_binary(bio) do
    username = login_as!(token)
    validate_bio!(bio)

    username
    |> user_profile
    |> update(set: [bio: ^bio])
    |> Repo.update_all([])
    ok()
  end

  def change_icon(token, data_url)
      when is_binary(token) and is_binary(data_url) do
    username = login_as!(token)

    image_hash =
      case unpack_data_url(data_url) do
        {:ok, data} -> Memes.ValueStore.put(data)
        :error -> error("Invalid DataURL")
      end

    username
    |> user_profile
    |> update(set: [icon: ^image_hash])
    |> Repo.update_all([])
    ok(image_hash)
  end

  def reset_password(username, email)
      when is_binary(username) and is_binary(email) do
    import Ecto.Query, only: [from: 2]
    validate_username!(username)
    validate_email!(email)

    q =
      from a in "accounts",
      where: a.username == ^username and a.email == ^email,
      select: count(a.username)

    case Memes.Repo.all(q) do
      [0] ->
        error("Invalid username or email")
      [1] ->

        new_pass = gen_password()
        hash = hashpwsalt(new_pass)

        q =
          from a in "accounts",
          where: a.username == ^username,
          update: [set: [password_hash: ^hash]]

        Repo.update_all(q, [])

        header =
          ["Subject: Password Reset on Monkey's Dictionary",
           "MIME-Version: 1.0",
           "Content-Type: text/html"]

        text = """
        <p>Hello #{username},</p>
        <p>We wanted let you know that your password was changed to '#{new_pass}'.</p>
        <p>Please do not reply to this email with your password. We will
        never ask for your password, and we strongly discourage you from
         sharing it with anyone.</p>
        <p>Regards,<br/>
        Monkey's Dictionary Team</p>
        """
        send_email(email, header, text)
        ok()
    end
  end

  defp gen_password do
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$_'
    1..10
    |> Enum.map(fn _ -> Enum.random(chars) end)
    |> to_string
  end

  @email_relay Application.get_env(:memes, :email_relay)
  @email_username Application.get_env(:memes, :email_username)
  @email_password Application.get_env(:memes, :email_password)

  defp send_email(addr, header, text) do
    require Logger
    payload = Enum.join(header, "\r\n") <> "\r\n" <> text
    mail = {@email_username, [addr], payload}

    result =
      :gen_smtp_client.send_blocking mail,
        relay: @email_relay,
        username: @email_username,
        password: @email_password,
        port: 587,
        tls: :always,
        auth: :always

    Logger.debug("SMTP: #{inspect result}")
  end

  defp user_account(username) do
    "accounts"
    |> where([username: ^username])
  end

  defp user_profile(username) do
    "profiles"
    |> where([username: ^username])
  end

  defp validate_username!(username) do
    username
    |> at_least!(3, "Username must be at least 3 characters")
    |> at_most!(20, "Username must not exceed 20 characters")
    |> matches!(~r/^[-_a-zA-Z0-9]{3,32}$/, "Username can only contain \
    hyphens, underscores and alphanumeric characters")
  end

  defp validate_password!(password) do
    password
    |> at_least!(1, "Password cannot be empty")
    |> at_least!(5, "Password must be at least 5 characters")
    |> at_most!(64, "Password must not exceed 64 characters")
  end

  defp validate_email!(email) do
    email
    |> matches!(~r/^\S+@\S+$/, "Invalid email format")
  end

  defp validate_name!(name) do
    name
    |> at_least!(3, "Name must be at least 3 characters")
    |> at_most!(20, "Name must not exceed 20 characters")
  end

  defp validate_bio!(bio) do
    bio
    |> at_most!(512, "Bio is at most 512 characters")
    |> matches!(~r/^([^\n]*\n){0,4}[^\n]*$/, "Bio can have at most 5 lines")
  end

  defp name_available!(username) do
    username
    |> user_account
    |> select([:username])
    |> Repo.all()
    |> case do
      [] -> username
      [_user] -> error("username is already taken")
    end
  end

  defp check_pass(username, password) do
    user_account(username)
    |> select([:password_hash])
    |> Repo.all()
    |> case do
      [] -> :username_nonexist
      [%{password_hash: hash}] -> Comeonin.Pbkdf2.checkpw(password, hash)
    end
  end

  defp check_pass!(username, password) do
    case check_pass(username, password) do
      true -> username
      _ -> error("Incorrect password")
    end
  end

  defp add_new_user(username, password, email) do
    hash = hashpwsalt(password)
    Repo.insert_all("accounts", [[username: username, password_hash: hash,
                                  email: email]])
    Repo.insert_all("profiles", [[username: username, name: username,
                                  bio: ""]])
  end

end
