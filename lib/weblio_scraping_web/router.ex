defmodule WeblioScrapingWeb.Router do
  use WeblioScrapingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
  # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WeblioScrapingWeb do
    pipe_through :api
    post "/translate", TranslateController, :show
  end
end
