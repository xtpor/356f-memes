defmodule Memes.Repo.Migrations.CreateReportForms do
  use Ecto.Migration

  def change do
    create table("report_forms") do
      add :name, :text
      add :email, :text
      add :subject, :text
      add :content, :text
    end
  end
end
