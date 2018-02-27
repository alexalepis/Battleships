defmodule ShipsTest do
    use ExUnit.Case
    doctest Battleships
    
   test "Check custom ship creation" do
      assert Ship.new(1,"Lula", 5)==%Ship{id: 1, length: 5, name: "Lula"}
   end


   
  end
  