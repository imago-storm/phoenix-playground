defmodule UserCreateAndLogin.Authenticator do
    alias UserCreateAndLogin.Session
    alias UserCreateAndLogin.Repo

    def find_session(id) do
        session = Repo.get(Session, id)
        case Repo.get(Session, id) do
            nil ->
                {:error}
            session ->
                {:ok, session}
        end
    end
end
