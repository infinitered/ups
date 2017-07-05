defmodule UPS do
  @moduledoc """
  Exposes functions to interact with the UPS API.

  ## Configuration
    config :ups,
      access_key: {:system, System.get_env("NAME_OF_ENV_VARIABLE")},
      username: {:system, System.get_env("NAME_OF_ENV_VARIABLE")},
      password: {:system, System.get_env("NAME_OF_ENV_VARIABLE")}
  """


  @doc """
  Validates address & returns a normalized version.

  ## Examples
      #=> address = %{
        name: "John Smith", # Optional
        building_name: "White House", # Optional
        full_address: "1600 Pennsylvania Ave NW",
        city: "Washington",
        state: "DC",
        zip: "20500",
        country: "US"
      }

      #=> UPS.validate_address("/XAV", address)
  """
  @spec validate_address(map) ::
    {:ok, map} |
    {:error, map} |
    {:error, HTTpoison.Error.t}
  def validate_address(address) do
    UPS.API.AddressValidation.HTTP.post("/XAV", address)
  end
end
