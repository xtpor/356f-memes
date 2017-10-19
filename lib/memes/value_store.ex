defmodule Memes.ValueStore do
  import Ecto.Query, only: [from: 2]

  @table "images"

  @spec put(binary()) :: binary()
  def put(data) when is_binary(data) do
    sha1 = sha1_hash(data)
    case exist?(sha1) do
      true -> nil
      false -> Memes.Repo.insert_all(@table, [[hash: sha1, value: data]])
    end
    sha1
  end

  @spec get(binary()) :: {:ok, binary()} | :error
  def get(hash) when is_binary(hash) do
    q =
      from g in @table,
      where: g.hash == ^hash,
      select: g.value

    case Memes.Repo.all(q) do
      [data] -> {:ok, data}
      [] -> :error
    end
  end

  defp exist?(hash) do
    q =
      from g in @table,
      where: g.hash == ^hash,
      select: g.hash

    case Memes.Repo.all(q) do
      [^hash] -> true
      [] -> false
    end
  end

  def sha1_hash(data) do
    :crypto.hash(:sha, data)
    |> Base.encode16
    |> String.downcase
  end

end
