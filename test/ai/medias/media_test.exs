defmodule Ai.Medias.MediaTest do
  use Ai.DataCase
  alias Ai.Medias.Media


  @valid_attrs %{title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Media.changeset(%Media{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Media.changeset(%Media{}, @invalid_attrs)
    refute changeset.valid?
  end
end
