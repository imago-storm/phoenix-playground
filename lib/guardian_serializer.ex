defmodule UserCreateAndLogin.GuardianSerializer do
    @behaviour Guardian.Serializer

    alias UserCreateAndLogin.Repo
    alias UserCreateAndLogin.User

    def for_token(user = %User{}), do: { :ok, "User:#{user.guid}" }
    def for_token(_), do: { :error, "Unknown resource type" }

    def from_token("User:" <> id), do: { :ok, Repo.get(User, id) }
    def from_token(_), do: { :error, "Unknown resource type" }
end
