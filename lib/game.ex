defmodule Game do

    defstruct [:game_id, :game_settings, :current_player, :enemy_player]
    
    def new(game_id, game_settings, first_move) do
        %Game{  game_id:        game_id,
                game_settings:  game_settings,
                current_player:        nil,
                enemy_player:        nil,
               }
    end

    def add_player(game, id, name) do
        player = Player.new(id, name, game.game_settings.board, game.game_settings.fleet)

        cond do
            game.current_player == nil -> %{game| current_player: player} 
            game.enemy_player == nil -> %{game| enemy_player: player} 
        end
         
    end

    def make_move(game, x, y) do
        {state, result}=shot(game, x, y)
        case {state, result} do
            {:error, :out_of_bounds} -> IO.puts("Shot out of bounds")
            {:error, :already_shot}  -> IO.puts("This shot has already been placed")
            {:error, :miss}          -> current_shot_board=Board.add_value(game.current_player.shot_board, x, y, :miss)
            {:ok, hit_ship}          -> 
                Board.add_value(game.current_player.shot_board, x, y, :hit)
                Board.replace_value(game.enemy_player.my_board, x, y, :hit)
                #Apply change on ship
        end

        #Check if current player won or else go to next move

        #RETURN GAME BUT SWAP PLAYERS SO 
        #IN THE NEXT MOVE, CURRENT_PLAYER IS 
        #THIS MOVE's ENEMY_PLAYER
    end

    def shot(game, x, y) do
        with :ok  <- in_bounds?(game, x, y),
             :ok  <- unique_shot?(current_player.shot_board, x, y),
             :ok  <- hit?(enemy_player.my_board, x, y)
        do
            {:ok, Board.get_position_value(enemy_player.my_board, x, y)}
        else
            {:error, :out_of_bounds} -> {:error, :out_of_bounds} 
            {:error, :already_shot}  -> {:error, :already_shot}
            {:error, :miss}          -> {:error, :miss}
        end
    end

    def hit?(board, x, y) do
        case Board.get_position_value(board, x, y)  do
            nil -> {:error, :miss}
            _   -> :ok
        end
    end

    def unique_shot?(board, x, y) do
        case Board.get_position_value(board, x, y)  do
            nil -> :ok
            _   -> {:error, :already_shot}
        end
    end

    def in_bounds?(game, x, y) do
       case  x<= game.board.n and y<= game.board.n do
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