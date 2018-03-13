defmodule Ai.Repo.Migrations.CreateCredential do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :provider, :string
      add :provider_uid, :string
      add :provider_token, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:credentials, [:provider, :provider_uid])
  end
end
