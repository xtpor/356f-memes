defmodule Memes.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table("accounts", primary_key: false) do
      add :username, :string, primary_key: true
      add :password_hash, :string
      add :email, :string
    end
  end
end
