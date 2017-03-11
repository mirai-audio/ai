defmodule Ai.Credential do
  use Ai.Web, :model

  alias Ai.User


  schema "credentials" do
    belongs_to :user, User

    field :provider, :string  # "email", "twitter", "google", etc
    field :provider_uid, :string  # unique id for the user, via the provider
    field :provider_token, :string

    field :password_hash, :string
    # Two virtual fields for password confirmation
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @providers ["email", "twitter"]
  @required_fields ~w(user_id provider provider_uid)
  @optional_fields ~w(
    provider_token
    password_hash
    password
    password_confirmation
  )

  @doc """
  Builds a email auth changeset based on the `struct` and `params`.

  If no params are supplied, an invalid changeset is returned without having
  performed any validation.
  """
  def email_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required([:user_id])
    |> validate_inclusion(:provider, @providers)
    |> validate_required([:provider_uid])
    |> validate_length(:provider_uid, min: 1)
    |> unique_constraint(:provider_uid, name: :credentials_provider_provider_uid_index)
    |> validate_length(:provider_uid, min: 7) # emails must be longer
    |> validate_format(:provider_uid, ~r/\S{1,}@\S{2,}.\S{2,}/u) # a@bb.cc, 🏎@🍔⚽️.👁🎉
    |> validate_length(:password, min: 12)
    |> validate_confirmation(:password)
    |> hash_password()
  end

  @doc """
  Builds a social network changeset based on `struct` and `params`.

  If no params are supplied, an invalid changeset is returned without having
  performed any validation.
  """
  def social_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required([:user_id])
    |> validate_inclusion(:provider, @providers)
    |> validate_required([:provider_uid])
    |> validate_length(:provider_uid, min: 1)
    |> unique_constraint(:provider_uid, name: :credentials_provider_provider_uid_index)
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset

  defp hash_password(%{valid?: true} = changeset) do
    hashedpw = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password))
    Ecto.Changeset.put_change(changeset, :password_hash, hashedpw)
  end
end
