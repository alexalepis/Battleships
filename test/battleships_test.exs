defmodule BoardTest do
  use ExUnit.Case
  doctest Battleships

  test "check empty 5x5 board cration" do
    assert Board.new(5) == %Board{
      map: %{
        {1, 1} => {:no_value},
        {1, 2} => {:no_value},
        {1, 3} => {:no_value},
        {1, 4} => {:no_value},
        {1, 5} => {:no_value},
        {2, 1} => {:no_value},
        {2, 2} => {:no_value},
        {2, 3} => {:no_value},
        {2, 4} => {:no_value},
        {2, 5} => {:no_value},
        {3, 1} => {:no_value},
        {3, 2} => {:no_value},
        {3, 3} => {:no_value},
        {3, 4} => {:no_value},
        {3, 5} => {:no_value},
        {4, 1} => {:no_value},
        {4, 2} => {:no_value},
        {4, 3} => {:no_value},
        {4, 4} => {:no_value},
        {4, 5} => {:no_value},
        {5, 1} => {:no_value},
        {5, 2} => {:no_value},
        {5, 3} => {:no_value},
        {5, 4} => {:no_value},
        {5, 5} => {:no_value}
      },
      n: 5
    }
    end

  
  test "check board size" do
    board = Board.new(5)
    assert Kernel.map_size(board.map) == 25 
  end
  
  test "check first index" do
    board = Board.new(5)
    assert board.map |> Map.fetch({1,1}) =={:ok, {:no_value}} 
  end
  
  test "check last index" do
    board = Board.new(5)
    assert board.map |> Map.fetch({5,5}) =={:ok, {:no_value}} 
  end
  
  test "check that all values are properly initialized" do
    board = Board.new(5)
    assert Enum.all?(board.map, fn{_k,v} -> v=={:no_value} end) == true
  end
 
end
