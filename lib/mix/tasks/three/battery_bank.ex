defmodule Mix.Tasks.Three.BatteryBank do
  def parse_lines(lines) do
    for line <- lines do
      String.split(line, "", trim: true)
    end
  end
end
