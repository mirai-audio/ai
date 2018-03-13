defmodule AiWeb.LoginController do
  @moduledoc """
  Login controller handles social login responses via Ueberauth.
  """
  use AiWeb, :controller
  plug(Ueberauth)
  alias Ai.Accounts
  alias Ai.Accounts.User
  alias Ueberauth.Strategy.Helpers


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

    # ToDo: assign a default username: username
    user_params = %{}
    user_changeset = User.changeset(%User{}, user_params)
    credential_params = get_credential_params(auth, provider, token)

    case Accounts.find_or_create_user(user_changeset, credential_params) do
      {:ok, _credential} ->
        url = get_redirect_url(credential_params.provider_uid, token)

        conn
        |> redirect(external: url)

      {:error, _reasons} ->
        conn
        |> redirect(to: "/")
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
