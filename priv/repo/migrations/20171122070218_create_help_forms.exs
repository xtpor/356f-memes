defmodule Memes.Repo.Migrations.CreateHelpForms do
  use Ecto.Migration

  def change do
    create table("help_forms") do
      add :name, :text
      add :email, :text
      add :subject, :text
      add :content, :text
    end
  end
end
