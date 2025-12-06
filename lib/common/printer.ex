defmodule Common.Printer do
  def print_grid(multi_dim_array) do
    :array.to_list(multi_dim_array)
    |> Enum.map(&:array.to_list/1)
    |> Enum.map(fn i ->
      Enum.join(i, " ")
      |> IO.puts()
    end)

    :ok
  end
end
