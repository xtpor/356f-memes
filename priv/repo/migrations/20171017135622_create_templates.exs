defmodule Memes.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table("templates", primary_key: false) do
      add :name, :string, primary_key: true
      add :hash, references("images", column: :hash, type: :string)
    end
  end

end
