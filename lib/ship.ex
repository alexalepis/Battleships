defmodule Ship do
  @moduledoc """
    Ships creates and manipulates the ships the game or the player commands it to.
  """

  defstruct [:id, :name, :length]

  @doc """
    Returns a new ship with the name and length that are passed as parameters.
  """
  def new(id, name, length) do
    %Ship{
      id: id,
      name: name,
      length: length
    }
  end

  @doc """
    Reduces the length of a ship, choosing the correct one from the fleet according to its ID.
    The ship length is used for keeping track of the still-alive or sunken ships of a player's fleet.
  """
  def reduce_length(ships, hit_ship_id) do
    ships
    |> Enum.reduce([], fn x, acc ->
      if x.id == hit_ship_id do
        [%{x | length: x.length - 1} | acc]
      else
        [x | acc]
      end
    end)
  end

  @doc """
    Checks if all the given ships have been sunk and if yes, returns true, else it returns false.
  """
  def ships_destroyed?(ships) do
    ships
    |> Enum.all?(fn
      %Ship{length: 0} -> true
      %Ship{length: _} -> false
    end)
  end

  @doc """
    Checks if the ship with the ID: hit_ship_id of the ships given, has been sunk (its length has reached 0).
  """
  def ship_destroyed?(ships, hit_ship_id) do
    ships
    |> Enum.find_value(&(&1.id == hit_ship_id and &1.length == 0))
  end
end
