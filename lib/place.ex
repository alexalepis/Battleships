defmodule Place do
    
    def random(ship, board) do
        case rand(2) do
            1 -> ship(ship, board, rand(board.n - ship.length), rand(board.n - ship.length),:vertical)
            2 -> ship(ship, board, rand(board.n - ship.length), rand(board.n - ship.length),:horizontal)
        end
    end

    def rand(n), do: :rand.uniform(n)

    def ship(ship, board, x, y, orientation ) do
        
        case valid_position?(ship, board, x, y, orientation ) do
            {:true,  board}     -> board
            {:false, message}   -> IO.puts message
                                   board
        end
    end

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