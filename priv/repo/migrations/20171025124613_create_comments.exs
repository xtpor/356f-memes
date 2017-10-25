defmodule Memes.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table("comments") do
      add :username, references("accounts", column: :username, type: :text)
      add :meme, references("memes", type: :string)
      add :created_at, :utc_datetime
      add :content, :text
    end
  end
end
