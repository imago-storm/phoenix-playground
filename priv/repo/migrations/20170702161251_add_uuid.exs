defmodule UserCreateAndLogin.Repo.Migrations.AddUuid do
  use Ecto.Migration
  alias UserCreateAndLogin.Repo
  alias UserCreateAndLogin.Session
  alias UserCreateAndLogin.User

  def change do

    Repo.delete_all(Session)
    Repo.delete_all(User)
    IO.puts "Deleted all sessions"

    alter table(:sessions) do
        remove :user_id
    end
    flush()

    alter table(:users) do
        remove :id
        add :guid, :uuid, null: false, primary_key: true
    end

    flush()

    # execute "ALTER TABLE sessions DROP CONSTRAINT sessions_user_id_fkey"
    # flush()

    # alter table(:sessions) do
    #     add :user_guid, references(:users, column: :guid, on_delete: :delete_all)
    # end

    # create index(:sessions, [:user_guid])

    # flush()

  end
end
