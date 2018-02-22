defmodule Board do
  # def new_board(n), do: new_board(0,0,n-1,%{})
  # defp new_board(n, n, n,map), do: Map.put(map, {n,n}, "-")
  # defp new_board(x, y, n, map) when y<n, do: new_board(x, y+1, n, Map.put(map, {x,y}, "-"))
  # defp new_board(x, y, n, map) when y==n, do: new_board(x+1, 0, n, Map.put(map, {x,y}, "-"))

  # credits stavrina 
  def new_board(sz) do
    y = for x<-1..sz ,y<-1..sz ,do: {{x,y} , {"-"}}
    Map.new(y)
  end

end
