defmodule Memes.Repo.Migrations.CreateMemes do
  use Ecto.Migration

  def change do
    create table("memes", primary_key: false) do
      add :id, :text, primary_key: true
      add :username, references("accounts", column: :username, type: :text)
      add :title, :text
      add :image, references("images", column: :hash, type: :string)
    end
  end
end
