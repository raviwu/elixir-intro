defmodule MyString do
  def printable?(string), do: _printable?(string, 0) == 0

  defp _printable?([], nonp_c_qty), do: nonp_c_qty
  defp _printable?([head|tail], nonp_c_qty) when head < ?\s, do: _printable?(tail, nonp_c_qty + 1)
  defp _printable?([head|tail], nonp_c_qty) when head > ?~, do: _printable?(tail, nonp_c_qty + 1)
  defp _printable?([head|tail], nonp_c_qty), do: _printable?(tail, nonp_c_qty)
end