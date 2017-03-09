defmodule ExceptionRaiser do
  def ok!({:ok, data}), do: data
  def ok!({_, message}), do: raise "Something Wrong: #{message}"
end