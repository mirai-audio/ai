defmodule Ai.Medias.Media do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ai.Accounts.User


  # use a UUID as the primary key
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "medias" do
    belongs_to(:user, User)

    field(:provider_uid, :string)
    field(:title, :string)
    field(:url, :string)

    timestamps()
  end

  @required_fields ~w(title url)
  @optional_fields ~w(provider_uid)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> extract_provider_uid()
    |> validate_required([:title, :url])
  end

  defp extract_provider_uid(changeset) do
    url = Ecto.Changeset.get_field(changeset, :url)
    provider_uid = get_provider_uid(url)
    Ecto.Changeset.put_change(changeset, :provider_uid, provider_uid)
  end

  defp get_provider_uid(nil), do: nil
  defp get_provider_uid(url) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.named_captures(url)
    |> get_in(["id"])
  end
end
