defmodule AiWeb.SessionController do
  @moduledoc """
  Session controller handles email login requests.
  """
  use AiWeb, :controller
  alias Ai.Credential
  import Comeonin.Bcrypt
  require Logger

  def create(conn, %{"grant_type" => "password", "username" => email, "password" => password}) do
    case find_user("email", email) do
      {:ok, user, credential} ->
        cond do
          checkpw(password, credential.password_hash) ->
            # Successful login
            Logger.info("authentication success for: '#{email}'.")
            # Encode a JWT
            {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)

            # Return token to the client
            conn
            |> json(%{access_token: jwt})

          true ->
            # Unsuccessful login
            Logger.warn("authentication attempt with wrong password for: '#{email}'.")

            # 401
            conn
            |> put_status(401)
            |> render(:errors, data: [%{code: 401, detail: nil}])
        end
      nil ->
        # user tried to login with email that does not exist
        Logger.warn("authentication attempt with non-existant user: '#{email}'.")

        # 401
        conn
        |> put_status(401)
        |> render(:errors, data: [%{code: 401, detail: nil}])
    end
  end

  def create(conn, %{"grant_type" => "token", "username" => provider_uid, "password" => token}) do
    case find_twitter_user(provider_uid, token) do
      {:ok, user, credential} ->
        # Successful login
        Logger.info("Twitter user '" <> credential.provider_uid <> "' logged in")
        # Encode a JWT
        {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)

        # Return JWT token to the client
        conn
        |> json(%{access_token: jwt})

      nil ->
        ("User '" <> provider_uid <> "' not found.")
        |> Logger.error()

        # 401
        conn
        |> put_status(401)
        |> render(AiErrorView, "401.json")
    end
  end

  def create(_conn, %{"grant_type" => _}) do
    # Handle unknown grant type
    msg = "Unsupported grant_type"
    Logger.error(msg)
    throw(msg)
  end

  defp find_user(provider, email) do
    case Repo.get_by(
           Credential,
           provider: provider,
           provider_uid: email
         ) do
      nil ->
        # no user found, return nil
        nil

      credential ->
        # return the user, {:ok, user}
        credential =
          credential
          |> Repo.preload([:user])

        {:ok, credential.user, credential}
    end
  end

  defp find_twitter_user(uid, token) do
    # get user from the database
    case Repo.get_by(
           Credential,
           provider: "twitter",
           provider_uid: uid,
           provider_token: token
         ) do
      nil ->
        # no user found, return nil
        nil

      credential ->
        # return the user, {:ok, user}
        credential =
          credential
          |> Repo.preload([:user])

        {:ok, credential.user, credential}
    end
  end
end
