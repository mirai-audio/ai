defmodule Ai.Medias.Media do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ai.Accounts.User
  alias Ai.MediaProvider


  # use a UUID as the primary key
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "medias" do
    belongs_to(:user, User)

    field(:provider, :string)
    field(:provider_uid, :string)
    field(:title, :string)
    field(:url, :string)

    timestamps()
  end

  @required_fields ~w(title url provider provider_uid)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> extract_url_details()
    |> validate_required([:provider, :provider_uid, :title, :url])
  end

  defp extract_url_details(changeset) do
    url = Ecto.Changeset.get_field(changeset, :url)
    case MediaProvider.parse!(url) do
      %MediaProvider{provider: provider, provider_uid: provider_uid} ->
        changeset
        |> Ecto.Changeset.put_change(:provider, provider)
        |> Ecto.Changeset.put_change(:provider_uid, provider_uid)
      {:error, message} ->
        changeset
        |> Ecto.Changeset.add_error(:provider, message)
    end
  end
end
