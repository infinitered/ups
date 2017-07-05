# UPS

Basic Elixir HTTPoison wrapper around the UPS street level validation API. This
wrapper could easily be extended to include more of UPS's offered APIs listed (here)[https://www.ups.com/upsdeveloperkit?loc=en_US]

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ups` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ups, "~> 0.1.0"}]
end
```

Otherwise, add this to your list of dependencies in `mix.exs`

```elixir
def deps do
  [{:ups, github: "infinitered/ups", tag: "v0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ups](https://hexdocs.pm/ups).

