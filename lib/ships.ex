defmodule Ships do
  @moduledoc """
    Ships creates and manipulates the ships the game or the player commands it to.
  """

  @ship_length [1,2,3]


@doc """
   Automatically creates a fleet given a list of ship lengths (i.e: [2,3,4] creates 3 ships with lengths 2,3 and 4 respectivelly.)
   If no parameter is passed it takes as default the @ship_length list and creates ships accordingly.
"""
  def fleet_creation(ship_length \\ ship_length= @ship_length) do
    ship_length    
    |> Enum.map_reduce(0, fn(x, acc) -> {new_ship(acc+1, x), acc+1} end)
    |> elem(0)
    |> Map.new
  end

@doc """
    Returns a new ship with the name and length that are passed as parameters.
"""
  defp new_ship(name_of_ship, length_of_ship) do
    {name_of_ship, length_of_ship}
  end
end