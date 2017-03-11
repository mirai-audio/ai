defmodule Ai.ErrorViewTest do
  use Ai.ConnCase, async: true

  import Phoenix.View

  test "renders 404.json" do
    assert render(Ai.ErrorView, "404.json", []) ==
      %{"errors" => [%{code: 404, title: "Not Found"}],
        "jsonapi" => %{"version" => "1.0"}}
  end

  test "render 500.json" do
    assert render(Ai.ErrorView, "500.json", []) ==
      %{"errors" => [%{code: 500, title: "Internal Server Error"}],
        "jsonapi" => %{"version" => "1.0"}}
  end

  test "render any other" do
    assert render(Ai.ErrorView, "505.json", []) ==
      %{"errors" => [%{code: 500, title: "Internal Server Error"}],
        "jsonapi" => %{"version" => "1.0"}}
  end
end
