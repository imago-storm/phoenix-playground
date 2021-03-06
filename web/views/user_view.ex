defmodule UserCreateAndLogin.UserView do
  use UserCreateAndLogin.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserCreateAndLogin.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserCreateAndLogin.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.guid,
      email: user.email,
      password: user.password}
  end

end
