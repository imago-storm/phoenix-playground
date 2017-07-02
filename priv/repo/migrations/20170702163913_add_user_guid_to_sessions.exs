defmodule UserCreateAndLogin.Repo.Migrations.AddUserGuidToSessions do
  use Ecto.Migration

  def change do

    alter table(:sessions) do
        remove :id
        add :guid, :uuid, primary_key: true
        add :user_guid, references(:users, type: :uuid, column: :guid, on_delete: :delete_all)
    end

    create index(:sessions, [:user_guid])

  end
end
