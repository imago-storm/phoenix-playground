defmodule UserCreateAndLogin.Plugs.Authenticate do

    import Plug.Conn
    require Logger
    alias UserCreateAndLogin.Authenticator

    def init(default), do: default

    def call(conn, _default) do
        headers = conn.req_headers
        {"x-session-id", session_id} = Enum.find(headers, fn(element) ->
          match?({"x-session-id", _}, element)
        end)

        Logger.debug(inspect(headers))

        case Authenticator.find_session(session_id) do
          {:ok, session} ->
            conn
            # |> put_session(:user_id, session.user_id)
            # |> configure_session(renew: true)
            |> assign(:user_id, session.user_id)
          {:error} ->
            Logger.debug ("auth failed")
            conn
            |> put_status(:forbidden)
            # |> render(UserCreateAndLogin.ErrorView, "403.json")
        end
    end

    def call(conn, default), do: assign(conn, :locale, default)
end
