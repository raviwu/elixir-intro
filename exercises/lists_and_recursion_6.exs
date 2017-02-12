defmodule MyList do
  def flatten([]), do: []
  def flatten([head | tail]) when is_list(head) and is_list(tail), do: flatten(head) ++ flatten(tail)
  def flatten([head | tail]) when (is_list(head) == false) and is_list(tail), do: [head] ++ flatten(tail)
  def flatten([head | tail]) when is_list(head) and (is_list(tail) == false), do: flatten(head) ++ [tail]
  def flatten([head | tail]), do: [head, tail]
end