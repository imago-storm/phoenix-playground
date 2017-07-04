defmodule UserCreateAndLogin.UserController do
  require Logger
  use UserCreateAndLogin.Web, :controller
  use Guardian.Phoenix.Controller
  import Plug.Conn

  alias UserCreateAndLogin.User
  alias UserCreateAndLogin.Authenticator

  # plug Guardian.Plug.EnsureAuthenticated,
  #   handler: UserCreateAndLogin.GuardianAuthErrorHandler
  # plug Guardian.Plug.EnsureResource,
  #   handler: UserCreateAndLogin.GuardianAuthErrorHandler

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    Logger.debug(inspect conn)
    render(conn, "show.json", user: user)
  end

  def profile(conn, _params, user, {:ok, claims}) do
    Logger.debug(inspect claims)
    user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(UserCreateAndLogin.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end


end
