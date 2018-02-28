defmodule PlacementTest do
  use ExUnit.Case
  doctest Battleships  

  def count_ship_coordinates(board), do: Enum.reduce(Map.values(board.map), 0,fn(x, acc) -> acc+check_if_empty(x) end)
  def check_if_empty({:no_value}), do: 0
  def check_if_empty(_), do: 1

  test "check default ship placement (horizontal)" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    ship  = List.last(fleet.ships)

    assert Place.custom(ship, board, 1, 1, :horizontal)=={:true, %Board{
      map: %{
        {1, 1} => {1},
        {1, 2} => {1},
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
    }}
  end

  test "check default ship placement (vertical)" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    ship  = List.last(fleet.ships)

    assert Place.custom(ship, board, 1, 1, :vertical)=={:true, %Board{
      map: %{
        {1, 1} => {1},
        {1, 2} => {:no_value},
        {1, 3} => {:no_value},
        {1, 4} => {:no_value},
        {1, 5} => {:no_value},
        {2, 1} => {1},
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
    }}
  end

  test "Place ship out of bounds" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    ship  = List.last(fleet.ships)

    assert Place.custom(ship, board, 5, 1, :vertical)=={:false, "coordinates not available"}
  end

  test "Place ship on other ship" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    last_ship  = List.last(fleet.ships)
    {:true,new_board} = Place.custom(last_ship, board, 1, 1, :vertical)

    first_ship = List.first(fleet.ships)

    assert Place.custom(first_ship, new_board, 1, 1, :vertical)=={:false, "place taken"}
  end

  test "CUSTOM placement of two ships on 5x5 map" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    first_ship  = List.first(fleet.ships)
    {:true,new_board} = Place.custom(first_ship, board, 2, 2, :vertical)

    last_ship = List.last(fleet.ships)

    assert Place.custom(last_ship, new_board, 1, 3, :vertical)=={true,
    %Board{
      map: %{
        {1, 1} => {:no_value},
        {1, 2} => {:no_value},
        {1, 3} => {1},
        {1, 4} => {:no_value},
        {1, 5} => {:no_value},
        {2, 1} => {:no_value},
        {2, 2} => {3},
        {2, 3} => {1},
        {2, 4} => {:no_value},
        {2, 5} => {:no_value},
        {3, 1} => {:no_value},
        {3, 2} => {3},
        {3, 3} => {:no_value},
        {3, 4} => {:no_value},
        {3, 5} => {:no_value},
        {4, 1} => {:no_value},
        {4, 2} => {3},
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
    }}
  end

  test "RANDOM placement of ship on 5x5 map (count non :no_value value occurences)" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    last_ship  = List.last(fleet.ships)
    {:true, new_board} = Place.random(last_ship, board)

    assert count_ship_coordinates(new_board)==2
  end

  test "RANDOM placement of two ships on 5x5 map (count non :no_value value occurences)" do
    board = Board.new 5
    fleet = Fleet.default_fleet
    last_ship  = List.last(fleet.ships)
    {:true, new_board} = Place.random(last_ship, board)
    first_ship = List.first(fleet.ships)
    {:true, new_board} = Place.random(first_ship, new_board)

    assert count_ship_coordinates(new_board)==5
  end



  



end