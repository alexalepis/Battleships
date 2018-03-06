defmodule Fleet do
  @moduledoc """
   Fleet creates and manipulates fleets of ships.
  """
  defstruct [:name, :ships]

  @type t :: %__MODULE__{name: name :: any(), ships: list()}
  @doc """
    Returns a new, empty fleet with the name passed as the parameter.
  """
  @spec new(any()) :: t
  def new(name) do
    %Fleet{name: name, ships: []}
  end

  @doc """
    Adds the ship[struct] given as parameter to the fleet given as parameter and returns the new fleet
  """
  @spec add_ship(Fleet.t(), list()) :: t
  def add_ship(fleet, ship) do
    %Fleet{fleet | ships: [ship | fleet.ships]}
  end

  @doc """
    Adds a ship with the parameters given as parameters, to the given fleet.
  """
  @spec add_ship(Fleet.t(), any(), any(), non_neg_integer()) :: t
  def add_ship(fleet, id, name, length) do
    ship = Ship.new(id, name, length)
    %Fleet{fleet | ships: [ship | fleet.ships]}
  end

  @doc """
   Automatically creates a fleet.
  """
  @spec default_fleet :: t
  def default_fleet do
    new("default_fleet")
    |> add_ship(1, :ship1, 1)
    |> add_ship(2, :ship2, 2)
    |> add_ship(3, :ship3, 3)
  end
end
