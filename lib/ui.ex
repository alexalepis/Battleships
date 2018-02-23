defmodule UI do
  def print(board, n) do
    board
    |> Map.values
    |> replace_with_ASCII
    |> Enum.chunk_every(n)
    # |> IO.inspect
  end

  def replace_with_ASCII([{"-"}|tail]), do: replace_with_ASCII(tail, []++[0])
  def replace_with_ASCII([_|tail]), do: replace_with_ASCII(tail, []++[0])
  def replace_with_ASCII([], list), do: list
  def replace_with_ASCII([{"-"}|tail], list), do: replace_with_ASCII(tail, list++[0])
  def replace_with_ASCII([{"ship_0"}|tail], list), do: replace_with_ASCII(tail, list++[1])
  def replace_with_ASCII([{"ship_1"}|tail], list), do: replace_with_ASCII(tail, list++[2])
  def replace_with_ASCII([{"ship_2"}|tail], list), do: replace_with_ASCII(tail, list++[3])
  def replace_with_ASCII([_|tail], list), do: replace_with_ASCII(tail, list++["#"])
  
    
end