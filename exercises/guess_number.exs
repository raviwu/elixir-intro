defmodule Chop do
  def guess(number, first..last), do: guess_number(number, first..last, get_current_number(first..last))

  def guess_number(number, _, current_number) when current_number == number do
    IO.puts "#{number}"
  end

  def guess_number(number, first..last, current_number) when current_number > number do
    IO.puts "It is #{current_number}"
    guess_number(number, first..current_number, get_current_number(first..current_number))
  end

  def guess_number(number, first..last, current_number) when current_number < number do
    IO.puts "It is #{current_number}"
    guess_number(number, current_number..last, get_current_number(current_number..last))
  end

  def get_current_number(first..last) do: div(last - first, 2) + first
end