defmodule Sum do
  def from(1), do: 1
  def from(n), do: n + from(n - 1)
end