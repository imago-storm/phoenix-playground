defmodule UserCreateAndLogin.OrderController do
  use UserCreateAndLogin.Web, :controller
  require Logger

  alias UserCreateAndLogin.Order
  alias UserCreateAndLogin.User

  # plug Guardian.Plug.EnsureAuthenticated,
  #   handler: UserCreateAndLogin.GuardianAuthErrorHandler

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    user_guid = user.guid

    orders = Order
    |> Ecto.Query.where(user_guid: ^user_guid)
    |> Repo.all

    render(conn, "index.json", orders: orders)
  end

  def create(conn, order_params) do
    user = Guardian.Plug.current_resource(conn)
    order_params_with_user = Map.put(order_params, "user_guid", user.guid)
    Logger.debug(inspect order_params_with_user)
    changeset = Order.changeset(%Order{}, order_params_with_user)

    case Repo.insert(changeset) do
      {:ok, order} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", order_path(conn, :show, order))
        |> render("show.json", order: order)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(UserCreateAndLogin.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Repo.get!(Order, id)
    render(conn, "show.json", order: order)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Repo.get!(Order, id)
    changeset = Order.changeset(order, order_params)

    case Repo.update(changeset) do
      {:ok, order} ->
        render(conn, "show.json", order: order)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(UserCreateAndLogin.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Repo.get!(Order, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(order)

    send_resp(conn, :no_content, "")
  end
end
