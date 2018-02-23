defmodule UI do
  def print(board, n) do
    board 
    |> Enum.sort 
    |> Enum.map(fn{k,v}-> replace(v) end)
    |> Enum.chunk_every(n)

  end

  def replace({:no_value}), do: 0
  def replace({number}),    do: number
    
end