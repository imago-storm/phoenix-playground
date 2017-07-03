defmodule UserCreateAndLogin.OrderView do
  use UserCreateAndLogin.Web, :view

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, UserCreateAndLogin.OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    %{data: render_one(order, UserCreateAndLogin.OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{id: order.guid,
      date: order.date,
      persons: order.persons,
      confirmed: order.confirmed}
  end
end
