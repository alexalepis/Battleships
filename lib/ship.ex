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

end