defmodule Board do
  def new_board(sz) do
    y = for x<-1..sz ,y<-1..sz ,do: {{x,y} , {:no_value}}
    Map.new(y)
  end
end
