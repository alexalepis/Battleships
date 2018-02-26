defmodule ShipsTest do
    use ExUnit.Case
    doctest Battleships
  
    
    test "check fleet creation" do
          assert Kernel.map_size(Ships.fleet_creation([4, 8, 10, 1, 2])) == 5 
    end
    
    test "check default fleet creation " do
          assert Kernel.map_size(Ships.fleet_creation) == 3 
    end

   
  end
  