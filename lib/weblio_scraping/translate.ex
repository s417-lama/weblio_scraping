defmodule WeblioScraping.Translate do
  defstruct error: %{}, found: true, suggestions: [], explanation: ""

  def weblio_search_url(query) do
    "https://ejje.weblio.jp/content_find?query=#{
      query |> String.split |> Enum.join("+")
    }&searchType=exact"
  end

  def search(query) do
    query
    |> weblio_search_url
    |> HTTPoison.get
    |> handle_search_result
  end

  def handle_search_result({:ok, %{status_code: 302, headers: headers}}) do
    {"Location", location} = List.keyfind(headers, "Location", 0)
    {:ok, location}
  end

  def handle_search_result({:ok, %{status_code: status}}) do
    {:error, %{status_code: status}}
  end

  def handle_search_result({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  def fetch(url) do
    url
    |> HTTPoison.get
    |> handle_fetch_result
  end

  def handle_fetch_result({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  def handle_fetch_result({:ok, %{status_code: status}}) do
    {:error, %{status_code: status}}
  end

  def handle_fetch_result({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  def parse_explanation(html) do
    result = html
    |> Floki.find("td.content-explanation")
    |> Floki.text

    case result do
      "" -> {:notfound, parse_suggestion(html)}
      _ -> {:ok, result}
    end
  end

  def parse_suggestion(html) do
    words = html
    |> Floki.find("span.nrCntSgT")
    |> Enum.map(&(Floki.text(&1)))

    explanations = html
    |> Floki.find("div.nrCntSgB")
    |> Enum.map(&(Floki.text(&1) |> String.trim))

    Enum.zip(words, explanations)
    |> Enum.map(fn({word, explanation}) ->
      %{word: word, explanation: explanation}
    end)
  end

end
