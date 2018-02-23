defmodule Random.Placement do
  
  def new(board, fleet, n) do

    my_board = 
    fleet 
    |> Enum.reduce( board, fn(x, acc) -> random_ship_placement(acc, x, n, 0) end ) 
   
    case my_board do
      %{value: :nil}  -> IO.puts "ERROR: Failed placement"
      _               -> UI.print(my_board, n)
    end
    
  end


  def random_ship_placement(board, {ship_name, ship_length}, n, failed_placement) do

    {orientation, x, y} = random_position(ship_length, n)
    
    case valid_position?(orientation, x, y, board, {ship_name, ship_length}, failed_placement ) do
      {true, board} -> board
      {false, 1000000 } -> %{value: :nil}
      {false, _   } -> random_ship_placement(board, {ship_name, ship_length}, n, failed_placement + 1)
    end
  end

  defp random_position(ship_length, n) do
    {Enum.random(0..1), Enum.random(0..n-ship_length), Enum.random(0..n-ship_length)}
  end

  defp valid_position?(_, _, _,board, {_, 0}, failed_placement), do: {true, board} 
  defp valid_position?(0, x, y, board, {ship_name, ship_length}, failed_placement) do
    case Map.get(board,{x,y}) do
      {:no_value} -> valid_position?(0, x+1, y, Map.replace!(board, {x,y}, {ship_name}), {ship_name, ship_length-1}, failed_placement)
      _     -> {false, failed_placement}
    end
  end
  defp valid_position?(1, x, y, board, {ship_name, ship_length}, failed_placement) do
    case Map.get(board,{x,y}) do
      {:no_value} -> valid_position?(1, x, y+1, Map.replace!(board, {x,y}, {ship_name}), {ship_name, ship_length-1}, failed_placement)
      _           -> {false, failed_placement}
    end
  end


end