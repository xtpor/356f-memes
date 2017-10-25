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

end
