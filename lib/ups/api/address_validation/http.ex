defmodule UPS.API.AddressValidation.HTTP do
  @moduledoc """
  HTTPoison wrapper for UPS API.
  """
  use HTTPoison.Base

  alias UPS.Config

  @behaviour UPS.API.AddressValidation

  # HTTPoison Callbacks
  # -------------------

  def process_url(path) do
    # if Mix.env == :prod do
    #   "https://onlinetools.ups.com/rest" <> path
    # else
    #   "https://wwwcie.ups.com/rest" <> path
    # end
    "https://onlinetools.ups.com/rest" <> path
  end

  def process_response_body(body) do
    with {:ok, json} <- Poison.decode(body) do
      format_response(json)
    else
      {:error, error} ->
        error
    end
  end

  def process_request_body(body) do
    new_body = %{
      "UPSSecurity" => %{
        "UsernameToken" => %{
          "Username" => Config.from_env(:ups, :username),
          "Password" => Config.from_env(:ups, :password)
        },
        "ServiceAccessToken" => %{
          "AccessLicenseNumber" => Config.from_env(:ups, :access_key)
        }
      },
      "XAVRequest" => %{
        "Request" => %{
          "RequestOption" => "1",
          "TransactionReference" => %{
            "CustomerContext" => "Customer Context"
          }
        },
        "MaximumListSize" => "10",
        "AddressKeyFormat" => %{
          "ConsigneeName" => body[:name],
          "BuildingName" => body[:building_name],
          "AddressLine" => [body[:line1], body[:line2] || ""],
          "PoliticalDivision2" => body[:city],
          "PoliticalDivision1" => body[:state],
          "PostcodePrimaryLow" => body[:zip],
          "CountryCode" => body[:country]
        }
      }
    }

    Poison.encode!(new_body)
  end

  def process_request_headers(_) do
    [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"},
      {"X-Requested-With", "JSONHttpRequest"}
    ]
  end

  defp format_response(%{"XAVResponse" => %{"ValidAddressIndicator" => "", "Candidate" => xav_candidate}} = response) do
    %{
      raw_body: response,
      address: format_address(xav_candidate),
      message: "Address is valid.",
      success: true
    }
  end
  defp format_response(%{"XAVResponse" => %{"AmbiguousAddressIndicator" => "", "Candidate" => candidates}} = response) do
    %{
      raw_body: response,
      suggestions: Enum.map(candidates, &format_address/1),
      message: "Address is not complete.",
      success: false
    }
  end
  defp format_response(response) do
    %{
      raw_body: response,
      message: "Address is not valid.",
      success: false
    }
  end

  defp format_address({"AddressKeyFormat", address}) do
    format_address(%{"AddressKeyFormat" => address})
  end
  defp format_address(%{"AddressKeyFormat" => address}) do
    base = %{
      city: address["PoliticalDivision2"],
      state: address["PoliticalDivision1"],
      country: address["CountryCode"],
      zip: address["PostcodePrimaryLow"] <> address["PostcodeExtendedLow"]
    }

    address_lines =
      if is_list(address["AddressLine"]) do
        %{
          line1: List.first(address["AddressLine"]),
          line2: List.last(address["AddressLine"]),
        }
      else
        %{
          line1: address["AddressLine"],
          line2: ""
        }
      end

    Map.merge(base, address_lines)
  end
end
