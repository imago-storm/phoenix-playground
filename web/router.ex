defmodule UserCreateAndLogin.Router do
  use UserCreateAndLogin.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :require_login_api do
    plug Guardian.Plug.EnsureAuthenticated, handler: UserCreateAndLogin.GuardianAuthErrorHandler
  end


  scope "/", UserCreateAndLogin do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

  end

  scope "/api", UserCreateAndLogin do
    pipe_through [:api, :require_login_api]
    resources "/users", UserController, except: [:new, :edit]
    # resources "/sessions", SessionController, except: [:new, :edit]
    get "/profile", UserController, :profile
    resources "/orders", OrderController, except: [:new, :edit]
    post "/users/registration", SessionController, :registration
  end

  scope "/api", UserCreateAndLogin do
    pipe_through :api

    post "/users/registration", SessionController, :registration
    post "/login", SessionController, :login
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserCreateAndLogin do
  #   pipe_through :api
  # end
end
