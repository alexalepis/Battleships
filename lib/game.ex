defmodule Game do
  defstruct [:game_id, :game_settings, :current_player, :enemy_player]

  @opaque g :: %Game{
            game_id: game_id,
            game_settings: %Game.Settings{},
            current_player: nil | %Player{},
            enemy_player: nil | %Player{}
          }
  @type game_id :: any
  @type player_id :: any
  @type player_name :: any

  @doc """
      Given an id and a struct of game settings it creates a new game with these parameters.
  """
  @spec new(game_id, %Game.Settings{}) :: g
  def new(game_id, game_settings) do
    %Game{game_id: game_id, game_settings: game_settings, current_player: nil, enemy_player: nil}
  end

  @doc """
      Adds the given player to the given game with the given ID.
  """
  @spec add_player(g, player_id, player_name) :: g
  def add_player(game, id, name) do
    player = Player.new(id, name, game.game_settings.board, game.game_settings.fleet)

    cond do
      game.current_player == nil -> %{game | current_player: player}
      game.enemy_player == nil -> %{game | enemy_player: player}
    end
  end

  @doc """
  Applies a missed shot to the current players shot_board.
  """
  def apply_move(game, x, y) do
    new_shot_board = Board.add_value(game.current_player.shot_board, x, y, :miss)
    %{game | current_player: %{game.current_player | shot_board: new_shot_board}}
  end

  @doc """
      Applies a shot that hit the ship with the ID: hit_ship_id to the current player's shot board, the current player's enemy_ship list
      and the enemy player's board.
  """
  def apply_move(game, x, y, hit_ship_id) do
    new_shot_board = Board.add_value(game.current_player.shot_board, x, y, :hit)

    enemy_player_board =
      Board.replace_value(game.enemy_player.my_board, x, y, {:hit, hit_ship_id})

    enemy_ships = Ship.reduce_length(game.current_player.enemy_fleet.ships, hit_ship_id)

    %{
      game
      | current_player: %{
          game.current_player
          | shot_board: new_shot_board,
            enemy_fleet: %{game.current_player.enemy_fleet | ships: enemy_ships}
        },
        enemy_player: %{game.enemy_player | my_board: enemy_player_board}
    }
  end

  @doc """
      Makes a move as the current player playing against the enemy player.
  """
  def make_move(game, x, y) do
    {state, result} = shot(game, x, y)

    case {state, result} do
      # {:error, :out_of_bounds} 
      {:error, :out_of_bounds} ->
        IO.puts("Shot out of bounds")
        game

      # {:error, :already_shot}
      {:error, :already_shot} ->
        IO.puts("This shot has already been placed")
        game

      {:error, :miss} ->
        apply_move(game, x, y)
        |> swap_players()

      {:ok, hit_ship} ->
        apply_move(game, x, y, hit_ship)
        |> check_sunk(hit_ship)
        |> swap_players()
        |> winner()
    end
  end

  @doc """
      Checks if the ship with the ID: hit_ship_id has been sunk.
  """
  def check_sunk(game, hit_ship_id) do
    case Ship.ship_destroyed?(game.current_player.enemy_fleet.ships, hit_ship_id) do
      true ->
        enemy_board = Board.replace_values(game.enemy_player.my_board, hit_ship_id)
        %{game | enemy_player: %{game.enemy_player | my_board: enemy_board}}

      _ ->
        game
    end
  end

  @doc """
      Checks if the player currently placed as the enemy player has won.
  """
  def winner(game) do
    cond do
      # {:ok, :game.current_player.id}
      Ship.ships_destroyed?(game.current_player.enemy_fleet.ships) == true ->
        IO.puts("winner #{game.current_player.id}")
        game

      # {:ok, :game.enemy_player.id}
      Ship.ships_destroyed?(game.enemy_player.enemy_fleet.ships) == true ->
        IO.puts("winner #{game.enemy_player.id}")
        game

      true ->
        game
    end
  end

  @doc """
      Swaps the player's structs in the game struct so in that the next make_move belongs to the other player.
  """
  def swap_players(game) do
    %{game | current_player: game.enemy_player, enemy_player: game.current_player}
  end

  @doc """
     Checks if the x and y given are in the boundaries of the enemy's map, if the shot has not already been
     placed and if the shot hits any ships when it's made. If it does, it returns the hit ship's id.
  """
  def shot(game, x, y) do
    with :ok <- in_bounds?(game, x, y),
         :ok <- unique_shot?(game.current_player.shot_board, x, y),
         :ok <- hit?(game.enemy_player.my_board, x, y) do
      {:ok, Board.get_position_value(game.enemy_player.my_board, x, y)}
    end
  end

  @doc """
     Checks if there is any ship at the position x, y on the board given.
  """
  def hit?(board, x, y) do
    case Board.get_position_value(board, x, y) do
      nil -> {:error, :miss}
      _ -> :ok
    end
  end

  @doc """
     Checks if the shot at x, y has already been placed or not.
  """
  def unique_shot?(board, x, y) do
    case Board.get_position_value(board, x, y) do
      nil -> :ok
      _ -> {:error, :already_shot}
    end
  end

  @doc """
     Checks if a shot at x, y can be made according to the boundaries of the board given.
  """
  def in_bounds?(game, x, y) do
    case x <= game.current_player.my_board.n and y <= game.current_player.my_board.n do
      true -> :ok
      false -> {:error, :out_of_bounds}
    end
  end
end
