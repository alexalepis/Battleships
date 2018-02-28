defmodule Game do

    defstruct [:game_id,:game_settings, :player1, :player2]
    
    def new(game_id, game_settings) do
        %Game{  game_id:        game_id,
                game_settings:  game_settings,
                player1:        nil,
                player2:        nil,
               }
    end

    def add_player(game, id, name) do
        player = Player.new(id, name, game.game_settings.board, game.game_settings.fleet)

        cond do
            game.player1 == nil -> %{game| player1: player} 
            game.player2 == nil -> %{game| player2: player} 
        end
         
    end
    
end

defmodule Game.Settings do

    defstruct [:board, :random_place, :fleet]
    
    def new(board_size \\ 5, random_place \\ :true, default_fleet \\ :true ) do
        
        game_settings = %Game.Settings{ board: Board.new(board_size),
                                        random_place: random_place}
        case default_fleet do
            :true -> %{game_settings | fleet: Fleet.default_fleet}
            _     -> %{game_settings | fleet: nil}
        end
    end

    def add_fleet(game_settings, fleet) do
        %{game_settings | fleet: fleet}
    end
end