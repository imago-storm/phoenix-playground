defmodule UserCreateAndLogin.Order do
  use UserCreateAndLogin.Web, :model

  @primary_key {:guid, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :guid}
  @foreign_key_type :binary_id

  schema "orders" do
    field :date, Ecto.DateTime
    field :persons, :integer
    field :confirmed, :boolean, default: false

    belongs_to :user, UserCreateAndLogin.User, foreign_key: :user_guid


    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:date, :persons, :confirmed, :user_guid])
    |> validate_required([:date, :persons, :confirmed, :user_guid])
  end
end
