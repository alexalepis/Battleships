defmodule UI do
  def print(board) do
    
    board.map 
    |> Enum.sort 
    |> Enum.map(fn{_,v}-> replace(v) end)
    |> Enum.chunk_every(board.n)
    |> IO.inspect

  end

  def replace({:no_value}), do: 0
  def replace({number}),    do: number
    
end