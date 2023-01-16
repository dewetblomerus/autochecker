defmodule Autochecker.PushoverClient do
  def send_message(params) do
    url = "https://api.pushover.net/1/messages.json"

    body =
      Map.merge(
        params,
        %{
          token: token(),
          user: user()
        }
      )
      |> Jason.encode!()

    HTTPoison.post(url, body, [{"Content-Type", "application/json"}], hackney: [pool: :default])
  end

  defp user do
    Application.fetch_env!(:autochecker, :pushover_user)
  end

  defp token do
    Application.fetch_env!(:autochecker, :pushover_token)
  end
end
