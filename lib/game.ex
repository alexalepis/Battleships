defmodule Game do

    defstruct [:game_id, :game_settings, :current_player, :enemy_player]
    
    def new(game_id, game_settings) do
        %Game{  game_id:        game_id,
                game_settings:  game_settings,
                current_player: nil,
                enemy_player:   nil,
               }
    end

    def add_player(game, id, name) do
        player = Player.new(id, name, game.game_settings.board, game.game_settings.fleet)

        cond do
            game.current_player == nil  -> %{game| current_player: player} 
            game.enemy_player == nil    -> %{game| enemy_player: player} 
        end
         
    end
    def apply_move(game, x, y) do
        new_shot_board=Board.add_value(game.current_player.shot_board, x, y, :miss)
        game=%{game | current_player:  %{game.current_player | shot_board: new_shot_board}}
    end

    def apply_move(game, x, y, hit_ship_id) do
        new_shot_board      = Board.add_value(game.current_player.shot_board, x, y, :hit)
        enemy_player_board  = Board.replace_value(game.enemy_player.my_board, x, y, :hit)
        
        new_fleet = game.current_player.enemy_fleet.ships 
        |> Enum.reduce([], fn 
                              x=%Ship{id: hit_ship_id, length: ship_length}, acc -> [ %{x | id: hit_ship_id, length: ship_length-1} | acc]  
                              x=%Ship{id: _}, acc                                -> [ x | acc]  
                            end )
        
        game=%{game | current_player:  %{game.current_player | shot_board: new_shot_board,
                                                               enemy_fleet: %{game.current_player.enemy_fleet | ships: new_fleet}},
                      enemy_player:    %{game.enemy_player   | my_board: enemy_player_board}}
    end

    def make_move(game, x, y) do
        {state, result}=shot(game, x, y)
        case {state, result} do
            {:error, :out_of_bounds} -> IO.puts("Shot out of bounds") 
                                        game
            {:error, :already_shot}  -> IO.puts("This shot has already been placed") 
                                        game
            {:error, :miss}          -> apply_move(game, x, y) 
                                        |> swap_players()
            {:ok, hit_ship}          -> apply_move(game, x, y, hit_ship) 
                                        |> swap_players()
               
        end
    end

    def swap_players(game) do
        %{ game | current_player: game.enemy_player, enemy_player: game.current_player}
    end

    def shot(game, x, y) do
        with :ok  <- in_bounds?(game, x, y),
             :ok  <- unique_shot?(game.current_player.shot_board, x, y),
             :ok  <- hit?(game.enemy_player.my_board, x, y)
        do
            {:ok, Board.get_position_value(game.enemy_player.my_board, x, y)}
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
       case  x<= game.current_player.my_board.n and y<= game.current_player.my_board.n do
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