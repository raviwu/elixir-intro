defmodule MyList do
  def max([ head | [] ]), do: head
  def max([ head | tail ]) do
    [second | remain_tail] = tail
    max([_max(head, second) | remain_tail])
  end
  
  defp _max(a, b) when a >= b, do: a
  defp _max(a, b) when a < b, do: b
end