defmodule Fleet do
  @moduledoc """
   Fleet creates and manipulates fleets of ships.
  """
  defstruct [:name, :ships]

  @doc """
    Returns a new, empty fleet with the name passed as the parameter.
  """
  def new(name) do
    %Fleet{name: name, ships: []}
  end

  @doc """
    Adds the ship[struct] given as parameter to the fleet given as parameter and returns the new fleet
  """
  def add_ship(fleet, ship) do
    %Fleet{fleet | ships: [ship | fleet.ships]}
  end

  @doc """
    Adds a ship with the parameters given as parameters, to the given fleet.
  """
  def add_ship(fleet, id, name, length) do
    ship = Ship.new(id, name, length)
    %Fleet{fleet | ships: [ship | fleet.ships]}
  end

  @doc """
   Automatically creates a fleet.
  """
  def default_fleet do
    new("default_fleet")
    |> add_ship(1, :ship1, 1)
    |> add_ship(2, :ship2, 2)
    |> add_ship(3, :ship3, 3)
  end
end
