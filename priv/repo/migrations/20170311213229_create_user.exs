defmodule Ai.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, size: 15  # Twitter has 15, for historic reasons

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
