defmodule Memes.Endpoint do
  use Plug.Router

  # Serve static from the 'priv/static' directory
  plug Plug.Static, at: "/", from: {:memes, "priv/static"}

  plug :match
  plug :dispatch

  post "/rpc" do
    rpc_handler = JsonRpc.method_mapper(Memes.RpcEndpoint)
    {:ok, text, conn} = read_body(conn)

    case JsonRpc.rpc(text, rpc_handler) do
      {:reply, response} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, response)
      :noreply ->
         send_resp(conn, 204, "")
    end
  end

  match _ do
    file_path =
      Path.join([Application.app_dir(:memes), 'priv', 'static', 'index.html'])
    send_file(conn, 200, file_path)
  end

end
