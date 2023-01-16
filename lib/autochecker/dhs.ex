defmodule Autochecker.DHS do
  require Logger
  alias Autochecker.API
  @base_url "https://ttp.cbp.dhs.gov/schedulerapi"

  def get_soonest_for_location(location_id) do
    url =
      "#{@base_url}/slots/asLocations?minimum=2&limit=100&serviceName=Global%20Entry&locationId=#{location_id}"

    API.get(url)
  end

  def appointments_available_at(location_id) do
    case get_soonest_for_location(location_id) do
      [] ->
        false

      body ->
        true
    end
  end
end
