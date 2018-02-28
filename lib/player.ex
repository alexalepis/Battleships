defmodule Player do
    
    defstruct [:id, :name, :my_board, :enemy_board, :enemy_fleet]

    def new(id, name, board, fleet) do
        %Player{ id:            id,
                 name:          name,
                 my_board:      board,
                 enemy_board:   board,
                 enemy_fleet:   fleet
                }
    end

    def place(player, :random) do

        place_result =
        player.enemy_fleet.ships
        |> Enum.reduce( {:true, player.my_board, ""}, fn(ship, board) -> Place.random(ship, board) end ) 
        
        case place_result do
          {:false, board, message}  -> message
          {:true,  board, message}  -> UI.print(board)
        end
    end

    def place(board, fleet, :custom) do
        
    end

end