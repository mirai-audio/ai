defmodule AiWeb.UserController do
  use AiWeb, :controller
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
    # ToDo: assign a default username: username
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
        |> render("show.json-api", data: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(AiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp find_or_create_user(user_changeset, credential_params) do
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

        # return the user
        {:ok, user}

      credential ->
        # a credential with a matching provider/provider_uid was found. User
        # has previously logged in.

        # return the user, {:ok, user}
        Repo.preload(credential, [:user])
    end
  end
end
