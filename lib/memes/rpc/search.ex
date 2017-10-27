defmodule Memes.Rpc.Search do
  import Memes.Rpc.Utils
  import Ecto.Query

  def search_user(keywords, limit \\ 50, offset \\ 0) when
      length(keywords) >= 1 and
      is_integer(limit) and
      is_integer(offset) do
    "profiles"
    |> select([:username, :icon, :bio])
    |> where([p], like(p.username, ^similar_to(keywords)))
    |> Memes.Repo.all
    |> ok
  end

  def search_meme(opts, limit \\ 50, offset \\ 0) when
      is_map(opts) and
      is_integer(limit) and
      is_integer(offset) do
    "memes"
    |> keywords(opts)
    |> before_date(opts)
    |> after_date(opts)
    |> created_by(opts)
    |> select([:id, :title, :image, :username, :created_at])
    |> Memes.Repo.all
    |> ok
  end

  defp similar_to(keywords) do
    "%" <> Enum.join(keywords, "%") <> "%"
  end

  defp keywords(query, %{"keywords" => keywords}) when is_list(keywords) do
    where(query, [m], like(m.title, ^similar_to(keywords)))
  end

  defp keywords(query, _) do
    query
  end

  defp before_date(query, %{"before" => date}) when is_binary(date) do
    {:ok, date, _} = DateTime.from_iso8601(date)
    where(query, [m], m.created_at <= ^date)
  end

  defp before_date(query, _) do
    query
  end

  defp after_date(query, %{"after" => date}) when is_binary(date) do
    {:ok, date, _} = DateTime.from_iso8601(date)
    where(query, [m], m.created_at >= ^date)
  end

  defp after_date(query, _) do
    query
  end

  defp created_by(query, %{"created_by" => creator}) when is_binary(creator) do
    where(query, [m], m.username == ^creator)
  end

  defp created_by(query, _) do
    query
  end

end
