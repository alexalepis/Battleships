defmodule Fleet do
    @moduledoc """
      Ships creates and manipulates the ships the game or the player commands it to.
    """
    defstruct [:name, :ships]
  
  @doc """
      Returns a new ship with the name and length that are passed as parameters.
  """
    def new(name) do
       %Fleet{name: name, ships: []}
    end

    def add_ship(fleet, ship) do
        %Fleet{fleet | ships: [ship | fleet.ships]}
    end
    def add_ship(fleet, id, name, length) do
        ship = Ship.new(id, name, length)
        %Fleet{fleet | ships: [ship | fleet.ships]}
    end

  
    @doc """
     Automatically creates a fleet given a list of ship lengths (i.e: [2,3,4] creates 3 ships with lengths 2,3 and 4 respectivelly.)
     If no parameter is passed it takes as default the @ship_length list and creates ships accordingly.
  """
    def default_fleet do
      
        new("default_fleet")
        |> add_ship(1, :ship1, 2)
        |> add_ship(2, :ship2, 1)
        |> add_ship(3, :ship3, 3)
    end
  end