
defmodule Memes.ValueStore do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def put(data) do
    GenServer.call(__MODULE__, {:put, data})
  end

  def get(hash) do
    GenServer.call(__MODULE__, {:get, hash})
  end

  def handle_call({:get, hash}, _from, store) do
    {:reply, Map.fetch(store, hash), store}
  end

  def handle_call({:put, data}, _from, store) do
    key = sha1_hash(data)
    {:reply, key, Map.put(store, key, data)}
  end

  defp sha1_hash(data) do
    :crypto.hash(:sha, data)
    |> Base.encode16
    |> String.downcase
  end

end
