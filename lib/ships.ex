defmodule Ships do
  @ship_length [2,1,3]

  def fleet_creation(ship_length \\ ship_length= @ship_length) do
    ship_length    
    |> Enum.map_reduce(0, fn(x, acc) -> {new_ship("ship_#{acc}", x), acc+1} end)
    |> elem(0)
    |> Map.new
  end

  defp new_ship(name_of_ship, length_of_ship) do
    {name_of_ship,length_of_ship}
  end
end