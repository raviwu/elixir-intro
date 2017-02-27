defmodule MyString do
  def calculate(string) do
    {first_num, [ calculator | last_num ]} = Enum.split_while(string, fn(x) -> not (x in [?+, ?-, ?*, ?/]) end)
  
    _calculate(_number_digits(first_num, 0), calculator, _number_digits(last_num, 0))
  end

  defp _calculate(first_num, ?+, last_num), do: first_num + last_num
  defp _calculate(first_num, ?-, last_num), do: first_num - last_num
  defp _calculate(first_num, ?*, last_num), do: first_num * last_num
  defp _calculate(first_num, ?/, last_num), do: first_num / last_num

  defp _number_digits([], value), do: value
  defp _number_digits([ digit | tail ], value) when digit in '0123456789' do
    _number_digits(tail, value * 10 + digit - ?0)
  end
  defp _number_digits([ non_digit | _ ], _) do
    raise "Invalid digit '#{[non_digit]}'"
  end
end