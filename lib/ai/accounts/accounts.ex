defmodule Ai.Accounts do
  @moduledoc """
  Accounts context.
  """

  import Ecto.Query, warn: false
  alias Ai.Repo
  alias Ai.Accounts.{User, Credential}


  @doc """
  Creates a user.
  ## Examples
      iex> create_user(%{username: "joan"})
      {:ok, %User{}}
      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credentials, with: &Credential.changeset/2)
    |> Repo.insert()
  end

  @doc """
  Return an existing email user, or create and return a user.

  ## Examples
      iex> find_or_create_email_user(%{}, %{
             provider: "email",
             provider_uid: "mike@example.com"})
      {:ok, %User{}} # existing user
      iex> find_or_create_email_user(User.changeset(%User{}, %{}),%{
             provider: "email",
             provider_uid: "mike@123.com",
             password: "Password1234",
             password_confirmation: "Password1234"})
      {:ok, %User{}} # new user
  """
  def find_or_create_email_user(user_changeset, credential_params) do
    case Repo.get_by(
           Credential,
           provider: credential_params.provider,
           provider_uid: credential_params.provider_uid
         ) do
      nil ->
        # no user credential was found, insert a new user
        {:ok, user} = Repo.insert(user_changeset)

        credential_params =
          credential_params
          |> Map.put(:user_id, user.id)

        # create and insert a new credential for that user
        Credential.email_changeset(%Credential{}, credential_params)
        |> Repo.insert()
        # return the user {:ok, %User}
        {:ok, user}

      credential ->
        # a credential with a matching provider/provider_uid was found. User
        # has previously logged in, but they just tried to recreate their
        # account. Thats ok, just return their existing user.
        credential =
          credential
          |> Repo.preload([:user])
        # return the user, {:ok, %User{}}
        {:ok, credential.user}
    end
  end

  @doc """
  Return an existing user, or create and return a user.

  ## Examples
      iex> find_or_create_user(%{}, %{
             provider: "twitter",
             provider_uid: "10446382",
             provider_token: "abc123def"})
      {:ok, %Credential{}} # existing user credential
      iex> find_or_create_user(%{
             username: "rob"}, %{
             provider: "twitter",
             provider_uid: "10446382",
             provider_token: "abc123def"})
      {:ok, %Credential{}} # new user credential
  """
  def find_or_create_user(user_changeset, credential_params) do
    case Repo.get_by(
           Credential,
           provider: credential_params.provider,
           provider_uid: credential_params.provider_uid
         ) do
      nil ->
        # no user credential was found, insert a new user
        {:ok, user} = Repo.insert(user_changeset)

        credential_params =
          credential_params
          |> Map.put(:user_id, user.id)

        # create and insert a new credential for that user
        Credential.social_changeset(%Credential{}, credential_params)
        |> Repo.insert()

        # return the user
        {:ok, user}

      credential ->
        # a credential was found from the OAuth provider with the same uid. User
        # has previously logged in.
        credential =
          Ecto.Changeset.change(
            credential,
            provider_token: credential_params.provider_token
          )

        # OAuth provider typically sends a fresh OAuth token. Update credential
        # with the fresh one to lower the incidence of stale or expired tokens.
        case Repo.update(credential) do
          {:ok, credential} ->
            # preload the credential, and return credential
            credential =
              credential
              |> Repo.preload([:user])
            # return the user, {:ok, %User{}}
            {:ok, credential.user}

          {:error, changeset} ->
            # Something went wrong
            {:error, changeset}
        end
    end
  end

  @doc """
  Return a user and credential for an auth provider and provider uid.

  ## Examples
      iex> Accounts.find_user("email", "mike@example.com")
      {:ok, %User{}, %Credential{}}
  """
  def find_user(provider, provider_uid) do
    case Repo.get_by(
           Credential,
           provider: provider,
           provider_uid: provider_uid
         ) do
      nil ->
        # no user found, return nil
        nil

      credential ->
        # preload the user, {:ok, user}
        credential =
          credential
          |> Repo.preload([:user])

        {:ok, credential.user, credential}
    end
  end

  @doc """
  Return an existing twitter user.

  ## Examples
      iex> Accounts.find_twitter_user("01234", "abc123def")
      {:ok, %User{}, %Credential{}}
  """
  def find_twitter_user(provider_uid, provider_token) do
    # get user from the database
    case Repo.get_by(
           Credential,
           provider: "twitter",
           provider_uid: provider_uid,
           provider_token: provider_token
         ) do
      nil ->
        # no user found, return nil
        nil

      credential ->
        # preload the user, {:ok, user}
        credential =
          credential
          |> Repo.preload([:user])

        {:ok, credential.user, credential}
    end
  end

  @doc """
  Returns a user.

  ## Example

      iex> get_user!(12)
      %User{}

  """
  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:credentials)
  end


  @doc """
  Returns list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    |> Repo.all()
    |> Repo.preload(:credentials)
  end


  @doc """
  Update an existing user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
