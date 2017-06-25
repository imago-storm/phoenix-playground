

alias UserCreateAndLogin.User
User

IO.inspect(User)

User.find_and_confirm_password(%{email: "email", password: "password"})
