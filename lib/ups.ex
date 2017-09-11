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

      #=> UPS.validate_address(address)
  """
  @spec validate_address(map) ::
    {:ok, map} |
    {:error, UPS.ValidationError.t} |
    {:error, HTTPoison.Error.t}
  def validate_address(address, opts \\ []) do
    case address_validation_module().post("/XAV", address, opts) do
      {:ok, %HTTPoison.Response{body: %{success: true}}} = resp ->
        resp
      {:ok, %HTTPoison.Response{body: %{success: false} = body}}->
        error = 
          %UPS.ValidationError{
            message: body.message,
            raw_body: body.raw_body,
            suggestions: body[:suggestions] || []
          }

        {:error, error}
      other ->
        other
    end
  end

  defp address_validation_module do
    Application.get_env(:ups, :address_validation_module, UPS.API.AddressValidation.HTTP)
  end
end
