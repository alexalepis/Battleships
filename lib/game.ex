defmodule Game do
    
    def new(n) do
        game_id = :"game_#{:erlang.unique_integer()}"
        fleet   = Ships.fleet_creation
        board   = Board.new_board(n)
        player1_board = Random.Placement.new(board, fleet, n)
        player2_board = Random.Placement.new(board, fleet, n)
                    
    end

end