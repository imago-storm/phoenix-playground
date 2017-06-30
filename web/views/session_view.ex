defmodule UserCreateAndLogin.SessionView do
  use UserCreateAndLogin.Web, :view

  def render("index.json", %{sessions: sessions}) do
    %{data: render_many(sessions, UserCreateAndLogin.SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, UserCreateAndLogin.SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id,
      user_id: session.user_id}
  end

  def render("login.json", %{user: user, jwt: jwt, exp: exp}) do
    %{ user_id: user.id, expires: exp, jwt: jwt }
  end

  def render("new_user.json", %{user: user}) do
    %{id: user.id}
  end
end
