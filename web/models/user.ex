defmodule UserCreateAndLogin.User do


  use UserCreateAndLogin.Web, :model
  alias UserCreateAndLogin.Repo
  require Logger

  @primary_key {:guid, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :guid}

  schema "users" do
    field :email, :string
    field :password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email, [name: "users_email_index", message: "The email was already taken"])
  end

  def find_and_confirm_password(params) do
    email = params["email"]
    password = params["password"]

    user = Repo.get_by(__MODULE__, email: email)
    Logger.debug(inspect(user))

    case user do
      nil -> {:error, "No such user"}
      user ->
        if user.password == password do
          {:ok, user}
        else
          {:error, "Wrong password"}
        end
    end

  end
end
