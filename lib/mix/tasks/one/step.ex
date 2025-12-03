defmodule Mix.Tasks.One.Step do
  def parse_lines([line | next]) do
    pair = get_step_pair(line)
    parse_lines(next, [pair])
  end

  def parse_lines([line | next], result) do
    pair = get_step_pair(line)
    parse_lines(next, [pair | result])
  end

  def parse_lines([], result), do: Enum.reverse(result)

  def get_step_pair(line) do
    direction = String.at(line, 0)

    value =
      line
      |> String.slice(1..-1//1)
      |> String.to_integer()

    {parse_direction(direction), value}
  end

  def parse_direction(direction)
  def parse_direction("L"), do: :left
  def parse_direction("R"), do: :right
end
