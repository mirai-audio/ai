defmodule AiWeb do
  @moduledoc """
  AiWeb extension library for Phoenix Framework.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: AiWeb

      alias Ai.Repo
      import Ecto
      import Ecto.Query

      import AiWeb.Router.Helpers
      import AiWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/ai_web/templates", namespace: AiWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      use Phoenix.HTML

      import AiWeb.Router.Helpers
      import AiWeb.ErrorHelpers
      import AiWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Ai.Repo
      import Ecto
      import Ecto.Query
      import AiWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
