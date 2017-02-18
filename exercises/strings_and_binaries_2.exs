defmodule MyString do
  def anagram?(word1, word2), do: Enum.sort(downcase(word1)) == Enum.sort(downcase(word2))

  def downcase([]), do: []
  def downcase([head|tail]) when head >= ?A and head <= ?Z, do: [head - ?A + ?a|downcase(tail)]
  def downcase([head|tail]), do: [head|downcase(tail)]
end