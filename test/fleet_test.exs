defmodule FleetTest do
  use ExUnit.Case
  doctest Battleships

  test "check default fleet" do
    assert Fleet.default_fleet==%Fleet{
                                        name: "default_fleet",
                                        ships: [
                                          %Ship{id: 3, length: 3, name: :ship3},
                                          %Ship{id: 2, length: 1, name: :ship2},
                                          %Ship{id: 1, length: 2, name: :ship1}
                                        ]
                                      }
  end

  test "check last of default ships" do
    fleet = Fleet.default_fleet
    assert List.last(fleet.ships)==%Ship{id: 1, length: 2, name: :ship1}
  end

  test "create fleet and add ship to it" do
    my_fleet=Fleet.new("My Fleet")
    assert Fleet.add_ship(my_fleet, 1, "Lula", 4) == %Fleet{name: "My Fleet", ships: [%Ship{id: 1, length: 4, name: "Lula"}]}
  end

  

end