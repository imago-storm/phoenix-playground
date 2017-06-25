defmodule UserCreateAndLogin.GuardianAuthErrorHandler do
    require Logger
    use UserCreateAndLogin.Web, :controller

    def no_resource(conn, something) do
        Logger.debug(inspect(something))
        conn
        |> put_status(:forbidden)
        |> render(UserCreateAndLogin.ErrorView, "403.json")
    end
end
