defmodule Memes.Rpc.Template do
  import Ecto.Query, only: [from: 2]

  def list do
    q = from t in "templates", select: %{name: t.name, hash: t.hash}
    {:ok, Memes.Repo.all(q)}
  end

end
