defmodule Mix.Tasks.Two do
  alias Common.Reader
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    [file_path] = args

    {invalid_ids, invalid_ids_advanced} =
      file_path
      |> Reader.read_columns(",")
      |> parse_ranges()
      |> handle_ranges()

    print(invalid_ids, "invalid_ids")
    print(invalid_ids_advanced, "invalid_ids_advanced")

    IO.puts("Sum of invalid_ids: #{Enum.sum(invalid_ids)}")
    IO.puts("Sum of invalid_ids_advanced: #{Enum.sum(invalid_ids_advanced)}")
  end

  def print(list, label) do
    IO.puts("#{label}: ")

    for element <- list do
      IO.puts("  #{element}")
    end
  end

  def parse_ranges(columns, ranges \\ [])

  def parse_ranges([column | next], ranges) do
    [left, right] =
      for element <- String.split(column, "-") do
        String.to_integer(element)
      end

    parse_ranges(next, [{left, right} | ranges])
  end

  def parse_ranges([], ranges), do: Enum.reverse(ranges)

  def handle_ranges(ranges, collective_invalid_ids \\ [], collective_invalid_ids_advanced \\ [])

  def handle_ranges([], collective_invalid_ids, collective_invalid_ids_advanced),
    do: {collective_invalid_ids, collective_invalid_ids_advanced}

  def handle_ranges([range | next], collective_invalid_ids, collective_invalid_ids_advanced) do
    {left, right} = range
    {invalid_ids, invalid_ids_advanced} = handle_range(left, right - left, [], [])

    handle_ranges(
      next,
      invalid_ids ++ collective_invalid_ids,
      invalid_ids_advanced ++ collective_invalid_ids_advanced
    )
  end

  def handle_range(pointer, lives, invalid_ids \\ [], invalid_ids_advanced \\ [])

  def handle_range(_pointer, -1, invalid_ids, invalid_ids_advanced),
    do: {invalid_ids, invalid_ids_advanced}

  def handle_range(pointer, lives, invalid_ids, invalid_ids_advanced) do
    new_invalid_ids =
      if is_invalid_id(pointer) do
        [pointer | invalid_ids]
      else
        invalid_ids
      end

    new_invalid_ids_advanced =
      if is_invalid_id_advanced(pointer) do
        [pointer | invalid_ids_advanced]
      else
        invalid_ids_advanced
      end

    handle_range(pointer + 1, lives - 1, new_invalid_ids, new_invalid_ids_advanced)
  end

  def is_invalid_id(id) do
    id_str = Integer.to_string(id)
    len = String.length(id_str)

    if rem(len, 2) == 0 do
      is_invalid_id(len, id_str)
    else
      false
    end
  end

  def is_invalid_id(len, id_str) do
    half = Kernel.div(len, 2)
    first_half = String.slice(id_str, 0..(half - 1))
    second_half = String.slice(id_str, half..-1//1)
    first_half == second_half
  end

  # 1 1 1 1 1 1 | 1 1 1 1 1 1
  # half = 6
  # 6 -> 12 % 6 == 0 ? true -> coba check
  # 5 -> 12 % 5 == 0 ? false -> skip
  # 4 -> 12 % 4 == 0 ? true -> coba check per 4

  def is_invalid_id_advanced(id) do
    id_str = Integer.to_string(id)
    len = String.length(id_str)
    half = Kernel.div(len, 2)
    is_invalid_id(len, half, id_str)
  end

  def is_invalid_id(_len, 0, _id_str), do: false

  def is_invalid_id(_len, 1, id_str) do
    graphemes = String.graphemes(id_str)
    sample = Enum.at(graphemes, 0)
    Enum.all?(graphemes, fn grapheme -> grapheme == sample end)
  end

  def is_invalid_id(len, chunk, id_str) do
    can_be_divided = Kernel.rem(len, chunk) == 0

    if !can_be_divided do
      is_invalid_id(len, chunk - 1, id_str)
    else
      slice = String.slice(id_str, 0..(chunk - 1))

      is_repeating_sequence =
        id_str
        |> String.graphemes()
        |> Enum.chunk_every(chunk)
        |> Enum.map(fn graph_chunk -> Enum.join(graph_chunk, "") end)
        |> Enum.all?(fn chunk_slice -> chunk_slice == slice end)

      if !is_repeating_sequence do
        is_invalid_id(len, chunk - 1, id_str)
      else
        true
      end
    end
  end
end
