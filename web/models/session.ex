defmodule UserCreateAndLogin.Session do
  use UserCreateAndLogin.Web, :model

  schema "sessions" do
    belongs_to :user, UserCreateAndLogin.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id])
    |> validate_required([:user_id])
  end
end
