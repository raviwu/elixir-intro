defmodule MyString do
  def capitalize_sentences(string) do
    string
    |> String.split(". ")
    |> Enum.map(&String.capitalize(&1))
    |> Enum.join(". ")
  end
end