
defmodule Memes.DatabaseSeeding do
  import Memes.ValueStore, only: [sha1_hash: 1]

  def transform(filename) do
    filename
    |> to_string
    |> String.slice(7..-5)
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def add_all_data(image_list) do
    image_list
    |> Enum.map(fn {_, value, hash} -> [hash: hash, value: value] end)
    |> insert_all("images")

    image_list
    |> Enum.map(fn {name, _, hash} -> [name: name, hash: hash] end)
    |> insert_all("templates")
  end

  def insert_all(data, table) do
    max_num_entries = 200
    data
    |> Enum.chunk(max_num_entries, max_num_entries, [])
    |> Enum.map(&Memes.Repo.insert_all(table, &1))
  end

  def run do
    url = "https://gist.githubusercontent.com/xtpor/6ecee9a102bb3503c8cb0f263f019c67/raw/a602b16c6f665a17046b3d2ac9e48cb8a5a0674a/images.tgz"
    {:ok, %{body: content}} = HTTPoison.get(url)
    {:ok, list} = :erl_tar.extract({:binary, content}, [:compressed, :memory])

    list
    |> Enum.map(fn {filename, image_data} ->
      {transform(filename), image_data, sha1_hash(image_data)}
    end)
    |> add_all_data
  end

end

Memes.DatabaseSeeding.run
