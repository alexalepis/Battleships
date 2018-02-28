defmodule UI do
  def print(board) do
    
    y = for x <- 1..board.n, y <- 1..board.n, do: {{x, y}, 0}
    
    Map.new(y)
    |> Map.merge(board.map)
    |> Enum.sort 
    |> Enum.map(fn{_,v}-> v end)
    |> Enum.chunk_every(board.n)
    |> IO.inspect

  end
    
end