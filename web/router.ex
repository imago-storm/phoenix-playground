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
  end

  scope "/", UserCreateAndLogin do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

  end

  scope "/api", UserCreateAndLogin do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    # resources "/sessions", SessionController, except: [:new, :edit]
    post "/login", SessionController, :login
    get "/profile", UserController, :profile
    resources "/orders", OrderController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserCreateAndLogin do
  #   pipe_through :api
  # end
end
