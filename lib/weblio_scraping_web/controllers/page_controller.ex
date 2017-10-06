defmodule WeblioScrapingWeb.PageController do
  use WeblioScrapingWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
