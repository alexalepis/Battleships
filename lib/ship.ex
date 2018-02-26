defmodule Ship do
  @moduledoc """
    Ships creates and manipulates the ships the game or the player commands it to.
  """

  @ship_length [1,2,3]
  defstruct [:id, name: nil, :length]



@doc """
    Returns a new ship with the name and length that are passed as parameters.
"""
  defp new(id, length, name) do
   %Ship{
     id: 
   }
  end



  @doc """
   Automatically creates a fleet given a list of ship lengths (i.e: [2,3,4] creates 3 ships with lengths 2,3 and 4 respectivelly.)
   If no parameter is passed it takes as default the @ship_length list and creates ships accordingly.
"""
  def auto_fleet_creation(ship_length \\ ship_length= @ship_length) do
    ship_length    
    |> Enum.map_reduce(0, fn(x, acc) -> {new(acc+1, x), acc+1} end)
    |> elem(0)
    |> Map.new
  end
end