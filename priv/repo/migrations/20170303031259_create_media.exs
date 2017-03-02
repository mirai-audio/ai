defmodule Ai.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:medias) do
      add :title, :string
      add :url, :string

      timestamps()
    end

  end
end
