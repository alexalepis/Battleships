defmodule Game do

    defstruct [:game_id, :player1_id, :player2_id, :player1_fleet, :player2_fleet, :player1_board, :player2_board, :current_player, :winner]

   
    
    def new(n) do
        game_data=%Game{        
            game_id: : {:game, :erlang.unique_integer()},
            player1_id: :"player_#{:erlang.unique_integer()}",
            player2_id: :"player_#{:erlang.unique_integer()}",
            player1_fleet: Ships.fleet_creation,
            player2_fleet: Ships.fleet_creation,
            player1_board: Random.Placement.new(Board.new_board(n), Ships.fleet_creation, n),
            player2_board: Random.Placement.new(Board.new_board(n), Ships.fleet_creation, n),

            current_player: 1,
            winner: nil
        }

       game_data.current_player

        # %{game_data| player1_board: Random.Placement.new(Board.new_board(7), Ships.fleet_creation, 7)}
      
    end

end