defmodule Memes.RpcEndpoint do

  def fetch(url) when is_binary(url) do
    {:ok, "yes " <> url}
  end

end
