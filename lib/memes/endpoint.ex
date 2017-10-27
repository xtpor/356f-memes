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
        |> put_resp_header("cache-control", "public; max-age=31556926")
        |> send_resp(200, data)
      :error ->
        send_file(conn, 200, page_path())
    end
  end

  post "/rpc/search" do
    JsonRpc.plug(conn, Memes.Rpc.Search)
  end

  post "/rpc/trends" do
    JsonRpc.plug(conn, Memes.Rpc.Trends)
  end

  post "/rpc/image" do
    JsonRpc.plug(conn, Memes.Rpc.Image)
  end

  post "/rpc/template" do
    JsonRpc.plug(conn, Memes.Rpc.Template)
  end

  post "/rpc/account" do
    JsonRpc.plug(conn, Memes.Rpc.Account)
  end

  match _ do
    send_file(conn, 200, page_path())
  end

  defp page_path do
    Path.join([Application.app_dir(:memes), 'priv', 'static', 'index.html'])
  end

end
