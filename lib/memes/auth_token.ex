defmodule Memes.AuthToken do
  alias Joken.Token
  import Joken

  @sign_key Application.get_env(:memes, :sign_key)

  def issue(username) when is_binary(username) do
    %Token{}
    |> with_claim("username", username)
    |> with_signer(hs256(@sign_key))
    |> sign
    |> get_compact
  end

  def verify(token_str) do
    case verify!(token(token_str), hs256(@sign_key)) do
      {:ok, %{"username" => username}} -> {:ok, username}
      {:error, _} -> :error
    end
  end

end
