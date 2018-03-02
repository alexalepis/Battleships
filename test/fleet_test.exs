defmodule FleetTest do
  use ExUnit.Case
  doctest Battleships


  test "create fleet and add ship to it" do
    my_fleet=Fleet.new("My Fleet")
    assert Fleet.add_ship(my_fleet, 1, "Lula", 4) == %Fleet{name: "My Fleet", ships: [%Ship{id: 1, length: 4, name: "Lula"}]}
  end

  

end