defmodule Memes.Endpoint do
  use Plug.Router

  # Serve static from the 'priv/static' directory
  plug Plug.Static, at: "/", from: {:memes, "priv/static"}

  plug :match
  plug :dispatch

  get "/archive/:hash" do
    case Memes.ValueStore.get(hash) do
      {:ok, data} ->
        conn
        |> put_resp_header("content-type", "image/png")
        |> send_resp(200, data)
      :error ->
        send_file(conn, 200, page_path())
    end
  end

  post "/rpc" do
    JsonRpc.plug(conn, Memes.RpcEndpoint)
  end

  post "/rpc/template" do
    JsonRpc.plug(conn, Memes.Rpc.Template)
  end

  match _ do
    send_file(conn, 200, page_path())
  end

  defp page_path do
    Path.join([Application.app_dir(:memes), 'priv', 'static', 'index.html'])
  end

end
