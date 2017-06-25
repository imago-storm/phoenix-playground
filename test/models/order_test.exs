defmodule UserCreateAndLogin.OrderTest do
  use UserCreateAndLogin.ModelCase

  alias UserCreateAndLogin.Order

  @valid_attrs %{confirmed: true, date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, persons: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Order.changeset(%Order{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Order.changeset(%Order{}, @invalid_attrs)
    refute changeset.valid?
  end
end
