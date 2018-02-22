defmodule Player do
  
  def add_player(player_id, n) do
    enemy_board=Board.new_board(n)

    my_board =
    Ships.fleet_creation
    |> Enum.reduce( Board.new_board(n), fn(x, acc) -> random_ship_placement(acc, x, n) end ) 
    # |> IO.inspect

    UI.print(my_board)
  end


  def random_ship_placement(board, {ship_name, ship_length}, n) do

    {orientation, x, y} = random_position(ship_length, n)
    
    case valid_position?(orientation, x, y, board, {ship_name, ship_length}) do
      {true, board} -> board
      false         -> random_ship_placement(board, {ship_name, ship_length}, n)
    end
  end

  defp random_position(ship_length, n) do
    {Enum.random(0..1), Enum.random(0..n-ship_length),Enum.random(0..n-ship_length)}
  end

  defp valid_position?(_, _, _,board, {_, 0}), do: {true, board} 
  defp valid_position?(0, x, y, board, {ship_name, ship_length}) do
    case Map.get(board,{x,y}) do
      {"-"} -> valid_position?(0, x+1, y, Map.replace!(board, {x,y}, {ship_name}), {ship_name, ship_length-1})
      _     -> false
    end
  end
  defp valid_position?(1, x, y, board, {ship_name, ship_length}) do
    case Map.get(board,{x,y}) do
      {"-"} -> valid_position?(1, x, y+1, Map.replace!(board, {x,y}, {ship_name}), {ship_name, ship_length-1})
      _     -> false
    end
  end


end