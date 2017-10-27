defmodule Memes.Rpc.Trends do
  import Memes.Rpc.Utils
  import Ecto.Query

  def newest(limit \\ 50, offset \\ 0) do
    all_memes(limit, offset)
    |> order_by([m], desc: m.created_at)
    |> Memes.Repo.all
    |> ok
  end

  def popular_today(limit \\ 50, offset \\ 0) do
    popular_in_period(limit, offset, -1, "day")
  end

  def popular_this_week(limit \\ 50, offset \\ 0) do
    popular_in_period(limit, offset, -7, "day")
  end

  def popular_this_month(limit \\ 50, offset \\ 0) do
    popular_in_period(limit, offset, -1, "month")
  end

  defp popular_in_period(limit, offset, n, unit) do
    all_memes(limit, offset)
    |> where([m], m.created_at > datetime_add(^DateTime.utc_now, ^n, ^unit))
    |> order_by([m, p, nl, nc], desc: nl.likes)
    |> Memes.Repo.all
    |> ok
  end

  defp all_memes(limit, offset) do
    likes =
      "memes"
      |> join(:left, [m], l in "likes", m.id == l.meme)
      |> group_by([m], m.id)
      |> select([m, l], %{id: m.id, likes: count(l.username)})

    comments =
      "memes"
      |> join(:left, [m], c in "comments", m.id == c.meme)
      |> group_by([m], m.id)
      |> select([m, c], %{id: m.id, comments: count(c.username)})

    "memes"
    |> join(:left, [m], p in "profiles", m.username == p.username)
    |> join(:inner, [m], nl in subquery(likes), m.id == nl.id)
    |> join(:inner, [m], nc in subquery(comments), m.id == nc.id)
    |> select([m, p, nl, nc],
         %{icon: p.icon, likes: nl.likes, comments: nc.comments}
         |> merge(map(m, [:id, :username, :title, :created_at, :image])))
    |> limit(^limit)
    |> offset(^offset)
  end

end
