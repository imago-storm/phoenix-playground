defmodule UserCreateAndLogin.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :date, :utc_datetime
      add :persons, :integer
      add :confirmed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
