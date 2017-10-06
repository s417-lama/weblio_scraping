# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :weblio_scraping,
  ecto_repos: [WeblioScraping.Repo]

# Configures the endpoint
config :weblio_scraping, WeblioScrapingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Dpuj2/WdtuF8okWVJo8rdV6nF5+5MpBHyX4ouhdHd3pZs5LxqPVqTg1JGJsOtJAq",
  render_errors: [view: WeblioScrapingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WeblioScraping.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
