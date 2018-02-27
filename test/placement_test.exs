defmodule PlacementTest do
  use ExUnit.Case
  doctest Battleships  



  test "check last default horizontal ship placement" do
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

  test "check last default vertical ship placement" do
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

end