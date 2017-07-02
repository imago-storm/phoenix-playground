defmodule UserCreateAndLogin.Repo.Migrations.ChangeUserIdType do
  use Ecto.Migration
  alias Ecto.Adapters.SQL
  alias UserCreateAndLogin.Repo


  def change do

    qry = "SELECT * FROM users"
    res = Ecto.Adapters.SQL.query!(Repo, qry, [])
    IO.inspect(res)

  end
end
