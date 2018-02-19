defmodule Ai.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:medias) do
      add :user_id, references(:users, on_delete: :nothing)

      add :title, :string
      add :url, :string

      timestamps()
    end

    create index(:medias, [:user_id])
  end
end
