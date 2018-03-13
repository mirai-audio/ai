defmodule Ai.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ai.Accounts.Credential
  alias Ai.Medias.Media


  schema "users" do
    field(:username, :string)

    has_many(:credentials, Credential)
    has_many(:medias, Media)

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
    |> validate_length(:username, max: 50) # Twitter max-username length is 50
    |> unique_constraint(:username)
  end
end
