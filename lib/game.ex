defmodule Game do

    defstruct [:game_id,:game_settings, :player1, :player2]
    
    def new(game_id, game_settings) do
        %Game{  game_id:        game_id,
                game_settings:  game_settings,
                next_move:      :player1,
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

    #player1
    #       id:            id,
    #       name:          name,
    #       my_board:      board, me ta dika tou ploia
    #       shots_board:   board, keno pinaka 
    #       enemy_fleet:   fleet

    #player2
    #       id:            id,
    #       name:          name,
    #       my_board:      board, me ta dika tou ploia
    #       shots_board:   board, keno pinaka
    #       enemy_fleet:   fleet

    def load_enemy(game) do
        cond do
            game.next_move ==:player1 -> game.player2
            game.next_move ==:player2 -> game.player1
        end
    end
    def shot(player, game, x, y) do
         
        enemy_player = load_enemy(game)

        with 
            :ok  <- in_bounds?(x, y),
            :ok  <- unique_shot?(player.shots_board, x, y),
            :ok  <- hit?(enemy_player.my_board, x, y)
        do
             
            shots_board = Board.replace_value( enemy_player.my_board.map, x, y, :hit)  
            shots_board = Board.add_value( player.shots_board.map, x, y, :shot)
            {:ok, }

        else
            {:error, :out_of_bounds} -> {:error, :out_of_bounds} 
            {:error, :already_shot}  -> {:error, :already_shot}
            :miss                    -> 
        end
    end

    def hit?(board, x, y) do
        case Board.get_position_value(board, x, y)  do
            nil -> :miss
            _   -> :ok
        end
    end

    def unique_shot?(board, x, y) do
        case Board.get_position_value(board, x, y)  do
            nil -> :ok
            _   -> {:error, :already_shot}
        end
    end

    def in_bounds?(x, y) do
       case  x<= game.board.n and x<= game.board.n do
           true  -> :ok
           false -> {:error, :out_of_bounds}
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