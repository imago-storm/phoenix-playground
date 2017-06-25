defmodule UserCreateAndLogin.UserController do
  require Logger
  use UserCreateAndLogin.Web, :controller
  import Plug.Conn

  alias UserCreateAndLogin.User
  alias UserCreateAndLogin.Authenticator

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, _params) do
    Logger.debug("#{inspect(conn.body_params)}")
    # TODO validate headers
    user_params = conn.body_params
    changeset = User.changeset(%User{}, user_params)
    Logger.debug(inspect(changeset))

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(UserCreateAndLogin.ChangesetView, "error.json", changeset: changeset)
    end
  end

  # plug :authenticate, :client
  plug UserCreateAndLogin.Plugs.Authenticate

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    Logger.debug(inspect conn)
    render(conn, "show.json", user: user)
  end

  def profile(conn, _params) do
    Logger.debug(inspect conn.assigns)
    user_id = conn.assigns.user_id
    user = Repo.get!(User, user_id)
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


  defp authenticate(conn, :client) do
    do_auth(conn, action_name(conn))
  end

  defp do_auth(conn, action) when action in [:show, :delete, :profile] do
    headers = conn.req_headers
    {"x-session-id", session_id} = Enum.find(headers, fn(element) ->
      match?({"x-session-id", _}, element)
    end)

    case Authenticator.find_session(session_id) do
      {:ok, session} ->
        conn
        # |> put_session(:user_id, session.user_id)
        # |> configure_session(renew: true)
        |> assign(:user_id, session.user_id)
      {:error} ->
        Logger.debug ("auth failed")
        conn
        |> put_status(:forbidden)
        |> render(UserCreateAndLogin.ErrorView, "403.json")
    end
  end

  defp do_auth(conn, _action), do: conn

end
