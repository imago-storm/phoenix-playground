defmodule UserCreateAndLogin.Order do
  use UserCreateAndLogin.Web, :model

  schema "orders" do
    field :date, Ecto.DateTime
    field :persons, :integer
    field :confirmed, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:date, :persons, :confirmed])
    |> validate_required([:date, :persons, :confirmed])
  end
end
