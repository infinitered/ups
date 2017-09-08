defmodule UPS.API.AddressValidation do
  @moduledoc """
  Behaviour for address validation implementations.
  """

  @callback post(map, Keyword.t) ::
    {:ok, HTTPoison.Response.t} |
    {:error, HTTPoison.Error.t}
end
