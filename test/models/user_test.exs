defmodule Ai.UserTest do
  use Ai.ModelCase

  alias Ai.User

  @valid_attrs %{username: "a@bb.cc"}
  @valid_attrs_emoji %{username: "a🍔🎉.🍔🎉"}
  @invalid_attrs_empty %{}
  @invalid_attrs_nil %{username: nil}
  @invalid_attrs_too_long %{
    username: "123456789012345678901234567890123456789012345678901" # 51 chars
  }

  test "changeset with valid attributes: a@bb.cc" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with valid attributes: emoji" do
    changeset = User.changeset(%User{}, @valid_attrs_emoji)
    assert changeset.valid?
  end

  test "changeset with empty attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs_empty)
    assert changeset.valid?
  end

  test "changeset with nil username" do
    changeset = User.changeset(%User{}, @invalid_attrs_nil)
    assert changeset.valid?
  end

  test "changeset with username too long" do
    changeset = User.changeset(%User{}, @invalid_attrs_too_long)
    refute changeset.valid?
  end
end
