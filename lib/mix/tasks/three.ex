defmodule Mix.Tasks.Three do
  alias Mix.Tasks.Three.BatteryBank
  alias Common.Reader
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    [file_path] = args

    result =
      file_path
      |> Reader.read_lines()
      |> BatteryBank.parse_lines()
      |> calculate_all_banks()

    IO.inspect(result)
  end

  def calculate_all_banks(banks, sum \\ 0)

  def calculate_all_banks([bank | next], sum) do
    bank_max = calculate_bank(bank)
    # IO.inspect(bank)
    # IO.inspect(bank_max)
    # IO.puts("---")
    calculate_all_banks(next, sum + bank_max)
  end

  def calculate_all_banks([], sum), do: sum

  def calculate_bank(batteries, max \\ 0)
  def calculate_bank([], max), do: max
  def calculate_bank([_battery | []], max), do: max

  def calculate_bank([battery | next], bank_max) do
    combination = get_max_combination(battery, next)
    new_bank_max = Kernel.max(combination, bank_max)
    calculate_bank(next, new_bank_max)
  end

  def get_max_combination(battery, remaining_batteries, max \\ 0)
  def get_max_combination(_battery, [], max), do: max

  def get_max_combination(battery, [check | next], max) do
    combo = combine(battery, check)
    new_max = Kernel.max(combo, max)
    get_max_combination(battery, next, new_max)
  end

  def combine(str_num_1, str_num_2) do
    "#{str_num_1}#{str_num_2}"
    |> String.to_integer()
  end
end
