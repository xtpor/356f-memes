defmodule Memes.Rpc.Utils do

  def ok do
    {:ok, %{"status" => "ok"}}
  end

  def ok(result) do
    {:ok, %{"status" => "ok", "result" => result}}
  end

  def error(reason) do
    throw {:ok, %{"status" => "error", "reason" => reason}}
  end

  def at_least!(str, value, error_message) do
    case String.length(str) >= value do
      true -> str
      false -> error(error_message)
    end
  end

  def at_most!(str, value, error_message) do
    case String.length(str) <= value do
      true -> str
      false -> error(error_message)
    end
  end

  def matches!(str, regex, error_message) do
    case Regex.match?(regex, str) do
      true -> str
      false -> error(error_message)
    end
  end

  def login_as!(token) do
    case Memes.AuthToken.verify(token) do
      {:ok, username} -> username
      :error -> error("Not authenticated, invalid token")
    end
  end

  def login_as_admin!(token) do
    case login_as!(token) do
      "admin" -> "admin"
      _ -> error("Only admin are allowed")
    end
  end

  @email_relay Application.get_env(:memes, :email_relay)
  @email_username Application.get_env(:memes, :email_username)
  @email_password Application.get_env(:memes, :email_password)

  def send_plaintext_email(addr, subject, body) do
    header =
      ["Subject: #{subject}",
       "MIME-Version: 1.0",
       "Content-Type: text/plain"]
    send_email(addr, header, body)
  end

  def send_email(addr, header, text) do
    require Logger
    payload = Enum.join(header, "\r\n") <> "\r\n" <> text
    mail = {@email_username, [addr], payload}

    spawn(fn ->
      try do
        result =
          :gen_smtp_client.send_blocking mail,
            relay: @email_relay,
            username: @email_username,
            password: @email_password,
            port: 587,
            tls: :always,
            auth: :always
        Logger.debug("SMTP: #{inspect result}")
      catch
        _, _ -> Logger.debug("SMTP Failed: #{addr}")
      end
    end)
    :ok
  end

end
