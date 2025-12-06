defmodule Mix.Tasks.Four do
  alias Common.Printer
  alias Common.Reader
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    [file_path] = args

    {dimension, grid} = Reader.read_grid(file_path)
    {h, w} = dimension
    IO.puts("")
    Printer.print_grid(grid)

    IO.puts("\n==========#{h}hx#{w}w==========\n")
  end

  def handle_grid({height, width}, grid) do
  end
end
