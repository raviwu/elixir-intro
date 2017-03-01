defmodule MyString do
  def center(list) do
    Enum.each(list, fn (word) ->
      padded_space = (_width(list, 0) - String.length(word)) / 2 |> Float.floor |> round
      word
      |> String.pad_leading(round(padded_space) + String.length(word))
      |> IO.puts
    end)
  end

  defp _width([], max_width), do: max_width
  defp _width([ head | tail ], max_width) do
    if String.length(head) > max_width do
      _width(tail, String.length(head))
    else
      _width(tail, max_width)
    end
  end
end