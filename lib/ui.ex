defmodule UI do
  def print(board, n) do
    board
    |> Map.values
    |> Enum.chunk_every(n)
    |> IO.inspect
  end
end