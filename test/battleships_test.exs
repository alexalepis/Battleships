defmodule BattleshipsTest do
  use ExUnit.Case
  doctest Battleships

  test "greets the world" do
    assert Battleships.hello() == :world
  end
end
