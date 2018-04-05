defmodule Ai.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:medias, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all)
      add :provider, :string
      add :provider_uid, :string
      add :title, :string, null: false
      add :url, :string, null: false

      timestamps()
    end

    create index(:medias, [:user_id, :provider, :provider_uid, :title])
  end
end
