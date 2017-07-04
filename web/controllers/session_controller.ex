defmodule UserCreateAndLogin.SessionController do
  use UserCreateAndLogin.Web, :controller
  require Logger

  alias UserCreateAndLogin.Session
  alias UserCreateAndLogin.User

  def index(conn, _params) do
    sessions = Repo.all(Session)
    render(conn, "index.json", sessions: sessions)
  end

  def registration(conn, user_params) do
    changeset = User.changeset(%User{}, user_params)
    Logger.debug(inspect(changeset))

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("new_user.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(UserCreateAndLogin.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def login(conn, params) do
    case User.find_and_confirm_password(params) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(
          conn,
          user,
          :token,
          perms: %{ default: [:read_profile, :write_profile, :create_order]}
        )

        jwt = Guardian.Plug.current_token(new_conn)

        case Guardian.Plug.claims(new_conn) do
          {:ok, claims} ->
            exp = Map.get(claims, "exp")

            Logger.debug(inspect(claims))

            Logger.debug(inspect Guardian.Permissions.from_claims(claims))

            new_conn
              |> put_resp_header("authorization", "Bearer #{jwt}")
              |> put_resp_header("x-expires", Integer.to_string(exp))
              |> render "login.json", user: user, jwt: jwt, exp: exp

          _ ->
            conn
            |> put_status(:forbidden)
            |> render(UserCreateAndLogin.ErrorView, "403.json")
        end
        # Logger.debug(inspect(claims))
        # exp = Map.get(claims, "exp")


      {:error, reason} ->
        conn
        |> put_status(:forbidden)
        |> render(UserCreateAndLogin.ErrorView, "403.json")
    end
  end

  def login_admin(conn, params) do

  end

  def show(conn, %{"id" => id}) do
    session = Repo.get!(Session, id)
    render(conn, "show.json", session: session)
  end

  def update(conn, %{"id" => id, "session" => session_params}) do
    session = Repo.get!(Session, id)
    changeset = Session.changeset(session, session_params)

    case Repo.update(changeset) do
      {:ok, session} ->
        render(conn, "show.json", session: session)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(UserCreateAndLogin.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    session = Repo.get!(Session, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(session)

    send_resp(conn, :no_content, "")
  end
end
