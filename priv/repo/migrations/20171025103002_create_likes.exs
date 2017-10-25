defmodule Memes.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table("likes", primary_key: false) do
      add :meme, references("memes", type: :string), primary_key: true
      add :username, references("accounts", column: :username, type: :text), primary_key: true
    end
  end
end
