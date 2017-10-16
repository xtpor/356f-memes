defmodule Memes.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table("images", primary_key: false) do
      add :hash, :string, primary_key: true
      add :value, :binary
    end
  end
end
