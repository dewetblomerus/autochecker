defmodule Autochecker.API do
  use HTTPoison.Base

  def get(url) do
    case HTTPoison.get(url, [], accept: "application/json") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)

      {:ok, %HTTPoison.Response{status_code: other}} ->
        "Unexpected status code: #{other}"

      {:error, %HTTPoison.Error{reason: reason}} ->
        "Error: #{reason}"
    end
  end
end
