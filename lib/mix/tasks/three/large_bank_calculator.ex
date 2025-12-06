defmodule Mix.Tasks.Three.LargeBankCalculator do
  @default_pick [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

  def calculate_bank(batteries) do
    # turn list of battery into an array
    size = Enum.count(batteries)
    _batteries = :array.new(size)
  end

  def pick_batteries(batteries, indices \\ @default_pick) do
    IO.inspect(batteries |> :array.to_list())

    indices
    |> Enum.reduce([], fn index, acc -> [:array.get(index, batteries) | acc] end)
    |> Enum.reverse()
  end

  def next_indices(current, max) do
    current_rev = Enum.reverse(current)
    current_arr = :array.from_list(current_rev)
  end

  def move_once(arr, max, index \\ 0, prev_stays \\ false) do
    array_size = :array.size(arr)

    if index >= array_size do
      arr
    else
      element_value = :array.get(index, arr)

      if element_value < max do
      end
    end
  end

  def test(a) do
    Enum.reduce(0..99, a, fn i, acc ->
      :array.set(i, rem(i + 1, 10), acc)
    end)

    # |> :array.to_list()
    # |> IO.inspect()
  end
end
