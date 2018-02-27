defmodule Board do
@moduledoc """
  Board creates and manipulates the playing boards
"""

defstruct [:map, :n]
 
  @doc """
    Creates a new board sized sz x sz, containing the coordinates of each place on the board as the key and an atom :no_value as value. 
  """
  def new(n) do
    y = for x<-1..n ,y<-1..n ,do: {{x,y} , {:no_value}}
    %Board{ map: Map.new(y), n: n}
  end

  def get_position_value(board, x, y) do
    board.map
    |> Map.get({x,y})
  end
  
  def replace_value(board, x, y, value) do

    new_map = board.map
    |> Map.replace!({x,y}, {value})    

    %{ board | map: new_map }
  end

end
