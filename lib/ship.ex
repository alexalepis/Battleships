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

  def reduce_length(ships, hit_ship_id) do
    ships 
    |> Enum.reduce([], fn x, acc -> if x.length == hit_ship_id do 
                                      [ %{x | length: x.length-1} | acc ]
                                    else 
                                      [ x | acc] 
                                    end
                        end)
  end

  def ships_destroyed?(ships) do
    ships 
    |> Enum.all?( fn %Ship{length: 0} -> true
                     %Ship{length: _} -> false
                    end )
  end

  def ship_destroyed?(ships, hit_ship_id) do
    ships 
    |> Enum.find_value( &(&1.id==hit_ship_id and &1.length==0) )
  end
  
end