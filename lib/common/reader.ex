defmodule Common.Reader do
  require Logger

  def read_lines(path) do
    read_lines(File.read(path), path)
  end

  def read_lines({:ok, content}, _path) do
    content
    |> String.split("\n", trim: true)
  end

  def read_lines({:error, reason}, path) do
    Logger.error("cannot read file #{path}", reason: reason)
    exit({:shutdown, 1})
  end
end
