defmodule Ai.UnauthenticatedUserController do
  use Ai.Web, :controller

  alias Ai.Credential
  alias Ai.User

  def create(conn, %{
        "data" => %{
          "type" => "users",
          "attributes" => %{
            "email" => email,
            "password" => password,
            "password-confirmation" => password_confirmation
          }
        }
      }) do
    # ToDo: username: username
    user_params = %{}
    user_changeset = User.changeset(%User{}, user_params)

    credential_params = %{
      provider: "email",
      provider_uid: email,
      password: password,
      password_confirmation: password_confirmation
    }

    case find_or_create_user(user_changeset, credential_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Ai.UserView, "show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Ai.ChangesetView, "error.json", changeset: changeset)
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
        {:ok, user} = Repo.insert(user_changeset)

        credential_params =
          credential_params
          |> Map.put(:user_id, user.id)

        # create and insert a new credential for that user
        Credential.email_changeset(%Credential{}, credential_params)
        |> Repo.insert()

        # return the user
        {:ok, user}

      credential ->
        # return the user, {:ok, user}
        Repo.preload(credential, [:user])
    end
  end
end
