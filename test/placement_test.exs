defmodule PlacementTest do
  use ExUnit.Case
  doctest Battleships  

  test "check default ship placement (horizontal)" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    ship  = List.last(fleet.ships)
    {state, %Board{map: map}} =Board.place_custom(ship, board, 1, 1, :horizontal)
    assert state==:ok
    Enum.each(map, fn
      {{1,1}, value} -> assert value==1 
      {{2,1}, value} -> assert value==1
      end)
  end  

  test "Place ship out of bounds" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    ship  = List.last(fleet.ships)
    {state, _board} = Board.place_custom(ship, board, 5, 1, :horizontal)
    assert state==:error
  end

  test "Place ship on other ship" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    last_ship  = List.last(fleet.ships)
    {:ok,new_board} = Board.place_custom(last_ship, board, 1, 1, :vertical)

    first_ship = List.first(fleet.ships)

    {state, _board}=Board.place_custom(first_ship, new_board, 1, 1, :vertical)

    assert state==:error
  end

  test "CUSTOM placement of two ships on 10x10 map" do
    board = Board.new 10
    fleet = Fleet.default_fleet
    first_ship  = List.first(fleet.ships)
    {:ok,new_board} = Board.place_custom(first_ship, board, 1, 1, :horizontal)

    last_ship = List.last(fleet.ships)

    {state, %Board{map: map}}=Board.place_custom(last_ship, new_board, 2, 2, :vertical)
    assert state==:ok

    Enum.each(map, fn
      {{1,1},value} ->  assert value==3
      {{2,1},value} ->  assert value==3
      {{3,1},value} ->  assert value==3
      {{2,2},value} ->  assert value==1
      {{2,3},value} ->  assert value==1
    end)

  end

  test "RANDOM placement of ship on 5x5 map (count occurences)" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    last_ship  = List.last(fleet.ships)
    {:ok, new_board} = Board.place_random(last_ship, {:ok,board})    
    assert Enum.reduce(new_board.map, 0, fn({_key, value}, acc) -> if value==last_ship.id, do: acc+1 end)==1


  end

  test "RANDOM placement of two ships on 5x5 map (count occurences)" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    last_ship  = List.last(fleet.ships)
    {:ok, new_board} = Board.place_random(last_ship, {:ok, board})
    first_ship = List.first(fleet.ships)
    {:ok, new_board} = Board.place_random(first_ship, {:ok,new_board})

    assert Enum.reduce_while(new_board.map, 0, fn({_key, value}, acc) -> if value==first_ship.id, do: {:cont, acc + 1}, else: {:cont, acc} end)==3
    assert Enum.reduce_while(new_board.map, 0, fn({_key, value}, acc) -> if value==last_ship.id, do: {:cont, acc + 1}, else: {:cont, acc} end)==1
  end




  



  



end