defmodule UPS.ValidationError do
  defexception message: nil, raw_body: nil, suggestions: []
end
