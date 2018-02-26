defmodule BoardTest do
  use ExUnit.Case
  doctest Battleships

  
  test "check board size" do
        assert Kernel.map_size(Board.new_board(5)) == 25 
  end
  
  test "check first index" do
    assert Board.new_board(5) |> Map.fetch({1,1}) =={:ok, {:no_value}} 
  end
  
  test "check last index" do
    assert Board.new_board(5) |> Map.fetch({5,5}) =={:ok, {:no_value}} 
  end
  
  test "check that all values are properly initialized" do
    assert Enum.all?(Board.new_board(5), fn{_k,v} -> v=={:no_value} end) == true
  end
 
end
