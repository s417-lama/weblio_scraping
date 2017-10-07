defmodule WeblioScrapingWeb.TranslateController do
  use WeblioScrapingWeb, :controller
  alias WeblioScraping.Translate

  def show(conn, %{"query" => query}) do
    case Translate.search(query) do
      {:ok, location} ->
        case Translate.fetch(location) do
          {:ok, body} ->
            result = body
            |> Translate.parse_explanation
            |> make_json_format
            json conn, result

          {:error, reason} -> error_response(conn, reason)
        end

      {:error, reason} -> error_response(conn, reason)
    end
  end
  
  def make_json_format({:ok, explanation}) do
    %Translate{explanation: explanation}
  end

  def make_json_format({:notfound, suggestions}) do
    %Translate{found: false, suggestions: suggestions}
  end

  def error_response(conn, reason) do
    json conn, %Translate{error: %{reason: reason}, found: false}
  end

end
