defmodule Memes.Rpc.Account do
  import Memes.Rpc.Utils
  import Ecto.Query, only: [from: 2]

  def register(username, password, email)
      when is_binary(username) and is_binary(password) and is_binary(email) do
    with :ok <- validate_username(username),
         :ok <- validate_password(password),
         :ok <- validate_email(email),
         :ok <- name_available(username)
    do
      add_new_user(username, password, email)
      ok()
    else
      {:error, reason} -> error(reason)
    end
  end

  @name_format "username can only contain hyphens, underscores and alphanumeric characters"
  @name_too_long "username must not exceed 20 characters"
  @name_too_short "username must be at least 3 characters"

  defp validate_username(username) do
    len = String.length(username)
    pattern = ~r/^[-_a-zA-Z0-9]{3,32}$/
    cond do
      len < 3 ->
        {:error, @name_too_short}
      len > 20 ->
        {:error, @name_too_long}
      not Regex.match?(pattern, username) ->
        {:error, @name_format}
      true ->
        :ok
    end
  end

  @pass_empty "password cannot be empty"
  @pass_too_short "password must be at least 5 characters long"
  @pass_too_long "password cannot be longer than 64 characters"

  defp validate_password(password) do
    len = String.length(password)
    cond do
      len == 0 -> {:error, @pass_empty}
      len < 5 -> {:error, @pass_too_short}
      len > 64 -> {:error, @pass_too_long}
      true -> :ok
    end
  end

  @email_format "invalid email format"

  defp validate_email(email) do
    pattern = ~r/^\S+@\S+$/
    cond do
      not Regex.match?(pattern, email) -> {:error, @email_format}
      true -> :ok
    end
  end

  @already_exist "username is already taken"

  defp name_available(username) do
    query =
      from a in "accounts",
      where: a.username == ^username,
      select: a.username

    case Memes.Repo.all(query) do
      [] -> :ok
      [_user] -> {:error, @already_exist}
    end
  end

  defp add_new_user(username, password, email) do
    hash = Comeonin.Pbkdf2.hashpwsalt(password)
    Memes.Repo.insert_all("accounts", [[
      username: username,
      password_hash: hash,
      email: email
    ]])

    Memes.Repo.insert_all("profile", [[
      username: username, name: username, bio: ""
    ]])
  end

  def login(username, password) when is_binary(username) and is_binary(password) do
    query =
      from a in "accounts",
      where: a.username == ^username,
      select: a.password_hash

    case Memes.Repo.all(query) do
      [] ->
        error("Invalid username or password")
      [hash] ->
        case Comeonin.Pbkdf2.checkpw(password, hash) do
          true -> username |> Memes.AuthToken.issue |> ok
          false -> error("Invalid username or password")
        end
    end
  end

  def info(username) when is_binary(username) do
    query =
      from p in "profile",
      where: p.username == ^username,
      select: {p.name, p.bio}

    case Memes.Repo.all(query) do
      [] -> error("User not found")
      [{name, bio}] ->
        info = %{"username" => username, "name" => name, "bio" => bio}
        ok(info)
    end
  end

end
