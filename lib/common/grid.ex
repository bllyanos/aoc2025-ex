defmodule Common.Grid do
  def map(grid, dimension, iterator)

  def map(grid, {h, w}, iter_fn) do
    max_count = {h - 1, w - 1}
    apply_fn(grid, max_count, max_count, iter_fn)
  end

  defp apply_fn(grid, {-1, _}, _max_count, _iter_fn), do: grid

  defp apply_fn(grid, counter, max_count, iter_fn) do
    {max_row, max_col} = max_count
    {row_counter, col_counter} = counter
    {row, col} = {max_row - row_counter, max_col - col_counter}
    row_value = :array.get(row, grid)
    cell = :array.get(col, row_value)
    new_cell = iter_fn.({row, col}, cell)
    new_row_value = :array.set(col, new_cell, row_value)
    new_grid = :array.set(row, new_row_value, grid)
    next_counter = get_next_counter(counter, max_count)
    apply_fn(new_grid, next_counter, max_count, iter_fn)
  end

  def get_next_counter({row, col}, {_max_row, max_col}) do
    case {row, col} do
      {r, 0} -> {r - 1, max_col}
      {r, c} -> {r, c - 1}
    end
  end
end
