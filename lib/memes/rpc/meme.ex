defmodule Memes.Rpc.Meme do
  import Memes.Rpc.Utils
  import Ecto.Query
  import Ecto.Query.API, only: [map: 2]

  def trends(limit \\ 50, offset \\ 0) do
    "memes"
    |> join(:left, [m], p in "profiles", m.username == p.username)
    |> select([m, p], merge(map(m, [:id, :username, :title, :created_at, :image]),
                            %{icon: p.icon}))
    |> limit(^limit)
    |> offset(^offset)
    |> order_by([m], desc: m.created_at)
    |> Memes.Repo.all
    |> ok
  end

end
