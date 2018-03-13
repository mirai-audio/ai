defmodule Ai.Medias.Media do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ai.Accounts.User


  # use a UUID as the primary key
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "medias" do
    belongs_to(:user, User)

    field(:title, :string)
    field(:url, :string)

    timestamps()
  end

  @required_fields ~w(title url)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required([:title, :url])
  end
end
