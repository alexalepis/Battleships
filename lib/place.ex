defmodule Place do

    @orientation {:vertical, :horizontal}

    def custom(ship, board, x, y, orientation), do: valid_position?(ship, board, x, y, orientation)
    
    def random(ship, board=%Board{}) do
        place_result = valid_position?(ship, board, rand(board.n - ship.length), rand(board.n - ship.length), elem(@orientation, rand(2)-1))     
         case place_result do
             {:false, _, _} -> random(ship, board) 
             _              -> place_result
         end   
    end
    def random(ship, {_, board=%Board{}, _}) do
        place_result = valid_position?(ship, board, rand(board.n - ship.length), rand(board.n - ship.length), elem(@orientation, rand(2)-1))     
        case place_result do
            {:false, _, _} -> random(ship, board) 
            _              -> place_result
        end      
    end
    def random(_, {:false, board, message}), do: {:false, board, message}

    defp rand(n), do: :rand.uniform(n)

    defp valid_position?(%Ship{length: 0}, board, _, _, _), do: {:true, board, "Success"}
    defp valid_position?(ship, board, x, y, :vertical) do
        case Board.get_position_value(board, x, y) do
            nil      -> {:false, board, "coordinates not available"}
            {:no_value} -> valid_position?( %{ship | length: ship.length-1}, 
                                            Board.replace_value(board, x, y, ship.id),
                                            x+1,
                                            y,
                                            :vertical  )
            {_}         -> {:false, board, "place taken"}

        end
    end
    defp valid_position?(ship, board, x, y, :horizontal) do
        case Board.get_position_value(board, x, y) do
            {:nil}      -> {:false, board, "coordinates not available"}
            {:no_value} -> valid_position?( %{ship | length: ship.length-1}, 
                                            Board.replace_value(board, x, y, ship.id),
                                            x,
                                            y+1,
                                            :horizontal  )
            {_}         -> {:false, board, "place taken"}
        end
    end

end