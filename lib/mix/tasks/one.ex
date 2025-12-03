defmodule Mix.Tasks.One do
  alias Mix.Tasks.One.Step
  alias Common.Reader
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    [file_path] = args

    result =
      file_path
      |> Reader.read_lines()
      |> Step.parse_lines()
      |> process_steps()

    %{
      part_one_answer: part_one_answer,
      part_two_answer: part_two_answer,
      last_pointer: last_pointer
    } = result

    IO.puts("Part One answer: #{part_one_answer}")
    IO.puts("Part Two answer: #{part_two_answer}")
    IO.puts("Last pointer: #{last_pointer}")
  end

  @min 0
  @max 99

  def iter, do: @max + 1

  def process_steps(steps, pointer \\ 50, counter \\ 0, overlap_counter \\ 0)

  def process_steps([step | next], pointer, counter, overlap_counter) do
    {direction, value} = step
    {new_pointer, additional_overlap} = calculate_step(step, pointer)
    new_counter = if new_pointer == 0, do: counter + 1, else: counter
    new_overlap = overlap_counter + additional_overlap + Kernel.div(value, iter())

    print_process(
      pointer,
      direction,
      value,
      new_pointer,
      additional_overlap,
      new_counter,
      new_overlap
    )

    process_steps(next, new_pointer, new_counter, new_overlap)
  end

  def process_steps([], pointer, counter, overlap_counter) do
    %{last_pointer: pointer, part_one_answer: counter, part_two_answer: overlap_counter}
  end

  def calculate_step({:left, value}, pointer) do
    normalized_value = rem(value, iter())
    new_pointer = pointer - normalized_value
    additional_overlap_on_zero = if new_pointer == @min, do: 1, else: 0
    additional_overlap_from_zero = if pointer == @min, do: 0, else: 1

    if new_pointer < @min,
      do: {new_pointer + iter(), additional_overlap_from_zero},
      else: {new_pointer, additional_overlap_on_zero}
  end

  def calculate_step({:right, value}, pointer) do
    normalized_value = rem(value, iter())
    pointer = pointer + normalized_value
    if pointer > @max, do: {pointer - iter(), 1}, else: {pointer, 0}
  end

  def print_process(pointer, direction, value, new_pointer, additional, new_counter, new_overlap) do
    starting_pointer = String.pad_trailing(Integer.to_string(pointer), 6, " ")
    direction_symbol = get_direction_symbol(direction)
    formatted_value = String.pad_trailing(Integer.to_string(value), 8, " ")
    formatted_new_pointer = String.pad_trailing(Integer.to_string(new_pointer), 3, " ")

    "#{starting_pointer} + #{direction_symbol}#{formatted_value} -> #{formatted_new_pointer} (#{additional}) [#{new_counter},#{new_overlap}]"
    |> IO.puts()
  end

  def get_direction_symbol(:left), do: "L"
  def get_direction_symbol(:right), do: "R"
end
