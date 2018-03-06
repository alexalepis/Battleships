defmodule UI do
  def print(board) do
    # {"board.map", board.map} |> IO.inspect

    y =
      for x <- 1..board.n,
          y <- 1..board.n,
          do: {{x, y}, 0}

    # {"empty map", Map.new(y)} |> IO.inspect
    # {"merged map", Map.new(y) |> Map.merge(board.map)} |> IO.inspect

    Map.new(y)
    |> Map.merge(board.map)
    |> Enum.sort()
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.chunk_every(board.n)

    # |> IO.inspect
  end
end
