defmodule Ai.LoginController do
  @moduledoc """
  Login controller handles social login responses via Ueberauth.
  """
  use Ai.Web, :controller

  plug(Ueberauth)

  alias Ai.Credential
  alias Ai.User
  alias Ueberauth.Strategy.Helpers

  require Logger

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(external: "#{base_url()}/login")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> redirect(external: get_failure_redirect_url())
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    token = get_oauth_token(auth)
    # "twitter", "google", etc
    provider = Map.get(params, "provider")
    user_params = %{}
    user_changeset = User.changeset(%User{}, user_params)
    credential_params = get_credential_params(auth, provider, token)

    case find_or_create_user(user_changeset, credential_params) do
      {:ok, user} ->
        url = get_redirect_url(credential_params.provider_uid, token)

        conn
        |> put_session(:current_user, user)
        |> redirect(external: url)

      {:error, _reasons} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: "/")
    end
  end

  defp find_or_create_user(user_changeset, credential_params) do
    case Repo.get_by(
           Credential,
           provider: credential_params.provider,
           provider_uid: credential_params.provider_uid
         ) do
      nil ->
        # create and insert a new user
        # insert user
        user = Repo.insert(user_changeset)
        {:ok, %User{id: user_id}} = user

        # update credential_params with user_id
        credential_params =
          credential_params
          |> Map.put(:user_id, user_id)

        # create and insert a new credential for that user
        Credential.social_changeset(%Credential{}, credential_params)
        |> Repo.insert()

        # return the user
        {:ok, user}

      credential ->
        # update the credential with the fresh OAuth token
        credential =
          Ecto.Changeset.change(credential, provider_token: credential_params.provider_token)

        case Repo.update(credential) do
          {:ok, credential} ->
            # preload the credential
            user =
              credential
              |> Repo.preload([:user])

            # return the user
            {:ok, user}

          {:error, changeset} ->
            # Something went wrong
            {:error, changeset}
        end
    end
  end

  # Returns a URL to redirect for successful login
  defp get_redirect_url(identity, token) do
    code = "#{identity}::#{token}"

    ["#{base_url()}/torii/redirect.html", "?code=", code]
    |> IO.iodata_to_binary()
  end

  # Returns a URL to redirect for failed login
  defp get_failure_redirect_url() do
    ["#{base_url()}/login", "?success=", "false"]
    |> IO.iodata_to_binary()
  end

  # Returns OAuth token from Twitter API response.
  defp get_oauth_token(%{extra: %{raw_info: %{token: token}}}) do
    token
    |> List.to_string()
  end

  # Constructs and returns a credentials object.
  defp get_credential_params(%{uid: provider_uid}, provider, token) do
    # username = Map.get(auth.extra.raw_info.user, "screen_name")  # username
    # email = "#{username}@#{provider}"
    # avatar = auth.info.image  # avatar

    %{provider: provider, provider_uid: provider_uid, provider_token: token}
  end

  defp base_url do
    :ai
    |> Application.get_env(:mir_url)
  end
end
