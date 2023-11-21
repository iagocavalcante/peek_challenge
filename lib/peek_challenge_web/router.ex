defmodule PeekChallengeWeb.Router do
  use PeekChallengeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_live_flash
    plug :put_root_layout, {PeekChallengeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Jason
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: PeekChallengeWeb.Schema

    forward "/", Absinthe.Plug,
      schema: PeekChallengeWeb.Schema

  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:PeekChallenge, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PeekChallengeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", PeekChallengeWeb do
    pipe_through [:browser]

    live_session :public_session,
      on_mount: [
        PeekChallengeWeb.Nav
      ] do
      live "/", HomeLive, :home
    end
  end
end
