defmodule Place do

    @orientation {:vertical, :horizontal}

    def custom(ship, board, x, y, orientation), do: valid_position?(ship, board, x, y, orientation)
    
    def random(ship, board) do
        new_board = valid_position?(ship, board, rand(board.n - ship.length), rand(board.n - ship.length),elem(@orientation, rand(2)-1))
        case new_board do
            {:false, "place taken"} -> random(ship, board)
            _ -> new_board
        end       
    end

    def rand(n), do: :rand.uniform(n)



    def valid_position?(%Ship{length: 0}, board, _, _, _), do: {:true, board}

    def valid_position?(ship, board, x, y, :vertical) do
        case Board.get_position_value(board, x, y) do
            nil      -> {:false, "coordinates not available"}
            {:no_value} -> valid_position?( %{ship | length: ship.length-1}, 
                                            Board.replace_value(board, x, y, ship.id),
                                            x+1,
                                            y,
                                            :vertical  )
            {_}         -> {:false, "place taken"}

        end
    end

    def valid_position?(ship, board, x, y, :horizontal) do
        case Board.get_position_value(board, x, y) do
            {:nil}      -> {:false, "coordinates not available"}
            {:no_value} -> valid_position?( %{ship | length: ship.length-1}, 
                                            Board.replace_value(board, x, y, ship.id),
                                            x,
                                            y+1,
                                            :horizontal  )
            {_}         -> {:false, "place taken"}
        end
    end

end