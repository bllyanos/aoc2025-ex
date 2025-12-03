defmodule Mix.Tasks.One2 do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    IO.puts(args)
  end
end
