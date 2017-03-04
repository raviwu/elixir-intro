defmodule SalesTax do
  def calculate(file) do
    parse_lines(file)
    |> Enum.map(&parse_order(&1))
    |> _calculate
  end

  def parse_lines(file) do
    File.open!(file)
    |> IO.stream(:line)
    |> Enum.map(&String.trim(&1))
    |> drop_list_header
  end

  def drop_list_header([_head|tail]), do: tail

  def parse_order(line) do
    [id_str, ship_to_str, net_amount_str] = String.split(line, ",")

    {id, _} = Integer.parse(id_str)
    ship_to = String.replace(ship_to_str, ":", "") |> String.to_atom
    {net_amount, _} = Float.parse(net_amount_str)

    [id: id, ship_to: ship_to, net_amount: net_amount]
  end

  defp _calculate(orders) do
    for order <- orders do
      tax_rate = _tax_rates[order[:ship_to]] || 0
      total_amount = (1 + tax_rate) * order[:net_amount]
      [id: order[:id], ship_to: order[:ship_to], net_amount: order[:net_amount], total_amount: total_amount]
    end
  end

  defp _tax_rates, do: [ NC: 0.075, TX: 0.08 ]
end

SalesTax.calculate('exercises/strings_and_binaries_7.csv')
