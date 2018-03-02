defmodule Player do
    
    defstruct [:id, :name, :my_board, :shot_board, :enemy_fleet]

    def new(id, name, board, fleet) do
        %Player{ id:            id,
                 name:          name,
                 my_board:      board,
                 shot_board:    board,
                 enemy_fleet:   fleet
                }
    end

    def place_random(player) do
        player.enemy_fleet.ships
        |> Enum.reduce( {:ok, player.my_board}, fn(ship, board) -> Board.place_random(ship, board) end ) 
        |> is_placed?(player)
    end

    def place_custom(player, ship, x, y, orientation) do
        Board.place_custom(ship, player.my_board, x, y, orientation) 
        |> is_placed?(player)
    end

    def is_placed?(place_result, player) do
        case place_result do
            {:error, _}     ->  IO.puts "Error placement"  
                                player
            {:ok,  board}   ->  UI.print(board)
                                %{player | my_board: board}
        end
    end

end