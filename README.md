[![Build Status](https://semaphoreci.com/api/v1/ir/ups/branches/master/shields_badge.svg)](https://semaphoreci.com/ir/ups)

# UPS

Basic Elixir HTTPoison wrapper around the UPS street level validation API. This
wrapper could easily be extended to include more of UPS's offered APIs listed [here](https://www.ups.com/upsdeveloperkit?loc=en_US)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ups` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ups, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ups](https://hexdocs.pm/ups).

## Configuration

Add the following to your `config.exs` file:

```elixir
config :ups,
  access_key: {:system, "UPS_ACCESS_KEY"},
  username: {:system, "UPS_USERNAME"},
  password: {:system, "UPS_PASSWORD"}
```

## Usage

#### Address Validation

```elixir
iex> address = %{
  line1: "11815 NE 113th Street",
  line2: "Ste 104",
  city: "Vancouver",
  state: "Washington",
  zip: "98662",
  country: "US"
}

iex> UPS.validate_address(address)
{:ok, %{body: %{
  success: true,
  address: %{
    city: "VANCOUVER",
    country: "US",
    line1: "11815 NE 113TH ST",
    line2: "STE 104", state: "WA",
    zip: "986621640"
  },
  message: "Address is valid.",
  raw_body: %{
    "XAVResponse" => %{
      "Candidate" => %{
        "AddressKeyFormat" => %{
          "AddressLine" => ["11815 NE 113TH ST", "STE 104"],
          "CountryCode" => "US", "PoliticalDivision1" => "WA",
          "PoliticalDivision2" => "VANCOUVER", "PostcodeExtendedLow" => "1640",
          "PostcodePrimaryLow" => "98662",
          "Region" => "VANCOUVER WA 98662-1640"
        }
      },
      "Response" => %{
        "ResponseStatus" => %{
          "Code" => "1",
          "Description" => "Success"
        },
        "TransactionReference" => %{
          "CustomerContext" => "Customer Context"
        }
      },
      "ValidAddressIndicator" => ""
    }
  }}}}
```
