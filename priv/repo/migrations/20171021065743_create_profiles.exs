defmodule Memes.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table("profiles", primary_key: false) do
      add :username, references("accounts", column: :username, type: :text),
        primary_key: true
      add :name, :string
      add :bio, :string
      add :icon, references("images", column: :hash, type: :string)
    end
  end
end
