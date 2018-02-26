defmodule Board do
@moduledoc """
  Board creates and manipulates the playing boards
"""


  @doc """
    Creates a new board sized sz x sz, containing the coordinates of each place on the board as the key and an atom :no_value as value. 
  """
  def new_board(sz) do
    y = for x<-1..sz ,y<-1..sz ,do: {{x,y} , {:no_value}}
    Map.new(y)
  end
end
