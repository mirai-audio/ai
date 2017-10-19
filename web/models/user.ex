defmodule Ai.User do
  use Ai.Web, :model

  alias Ai.Credential

  schema "users" do
    field(:username, :string)

    has_many(:credentials, Credential)

    timestamps()
  end

  @allowed_fields ~w(username)

  @doc """
  Builds a changeset based on the `struct` and `params`.

  If no params are supplied, an invalid changeset is returned without having
  performed any validation.
  """
  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_length(:username, max: 15)
    |> unique_constraint(:username)
  end
end
