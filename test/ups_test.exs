defmodule UPSTest do
  use ExUnit.Case
  # doctest Ups

  describe ".validate_address" do
    test "validate address returns successful response when valid address is passed" do
      address = %{
        line1: "1600 Pennsylvania Ave NW",
        line2: "",
        city: "Washington",
        state: "DC",
        zip: "20500",
        country: "US"
      }

      {:ok, %{body: response}} = UPS.validate_address(address)

      expected_address = %{
        line1: "1600 PENNSYLVANIA AVE NW",
        line2: "",
        city: "WASHINGTON",
        state: "DC",
        zip: "205000005",
        country: "US"
      }

      assert response.success
      assert response.address == expected_address
      assert response.message == "Address is valid."
    end

    test "handles address with multiple address lines" do
      address = %{
        line1: "11815 NE 113th Street",
        line2: "Ste 104",
        city: "Vancouver",
        state: "Washington",
        zip: "98662",
        country: "US"
      }

      {:ok, %{body: response}} = UPS.validate_address(address)

      expected_address = %{
        line1: "11815 NE 113TH ST",
        line2: "STE 104",
        city: "VANCOUVER",
        state: "WA",
        zip: "986621640",
        country: "US"
      }

      assert response.success
      assert response.address == expected_address
      assert response.message == "Address is valid."
    end

    test "handles bad addresses with suggestions and without exceptions" do
      address = %{
        city: "shasts", 
        country: "US", 
        line1: "123 main street", 
        line2: nil,
        state: "AK", 
        zip: "01576"
      }

      {:ok, %{body: response}} = UPS.validate_address(address)
      refute response.success
      assert response.suggestions
      assert response.message == "Address is not complete."
    end

    test "returns suggestions when address is not complete" do
      address = %{
        line1: "11815 NE 1",
        line2: "",
        city: "Vancouver",
        state: "Washington",
        zip: "98662",
        country: "US"
      }

      {:ok, %{body: response}} = UPS.validate_address(address)

      refute response.success
      assert response.suggestions
      assert response.message == "Address is not complete."
    end

    test "returns raw errors when address is not passed correctly" do
      address = %{
        line1: "11815 NE 1",
        line2: "",
        city: "Vancouver",
        state: "",
        zip: "98662",
        country: ""
      }

      {:ok, %{body: response}} = UPS.validate_address(address)

      refute response.success
      assert response.raw_body["Fault"]
      assert response.message == "Address is not valid."
    end
  end
end
