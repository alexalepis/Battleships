defmodule Game do
  defstruct [:game_id, :game_settings, :current_player, :enemy_player]

  @type t :: %__MODULE__{
          game_id: any(),
          game_settings: Game.Settings.t(),
          current_player: nil | Player.t(),
          enemy_player: nil | Player.t()
        }

  # @type game_id :: any
  # @type player_id :: any
  # @type player_name :: any
  # @type x :: integer
  # @type y :: integer
  # @type hit_ship_id :: integer
  # @type error_msg :: {:error, msg :: atom()}

  @spec new(any(), Game.Settings.t) :: t
  def new(game_id, game_settings) do
    %Game{game_id: game_id, game_settings: game_settings, current_player: nil, enemy_player: nil}
  end

  @spec add_player(t, any(), any()) :: t
  def add_player(game, id, name) do
    player = Player.new(id, name, game.game_settings.board, game.game_settings.fleet)

    cond do
      game.current_player == nil -> %{game | current_player: player}
      game.enemy_player == nil -> %{game | enemy_player: player}
    end
  end

  @spec apply_move(t, non_neg_integer(), non_neg_integer()) :: t
  def apply_move(game, x, y) do
    new_shot_board = Board.add_value(game.current_player.shot_board, x, y, :miss)
    %{game | current_player: %{game.current_player | shot_board: new_shot_board}}
  end

  @spec apply_move(t, non_neg_integer(), non_neg_integer(), integer()) :: t
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

  @spec make_move(t, non_neg_integer(), non_neg_integer()) :: t
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

  @spec check_sunk(t, integer()) :: t
  def check_sunk(game, hit_ship_id) do
    case Ship.ship_destroyed?(game.current_player.enemy_fleet.ships, hit_ship_id) do
      true ->
        enemy_board = Board.replace_values(game.enemy_player.my_board, hit_ship_id)
        %{game | enemy_player: %{game.enemy_player | my_board: enemy_board}}

      _ ->
        game
    end
  end

  @spec winner(t) :: t
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

  @spec swap_players(t) :: t
  def swap_players(game) do
    %{game | current_player: game.enemy_player, enemy_player: game.current_player}
  end

  @spec shot(t, non_neg_integer(), non_neg_integer()) :: {:ok, t} | {:error, atom()}
  def shot(game, x, y) do
    with :ok <- in_bounds?(game, x, y),
         :ok <- unique_shot?(game.current_player.shot_board, x, y),
         :ok <- hit?(game.enemy_player.my_board, x, y),
         game <- Board.get_position_value(game.enemy_player.my_board, x, y) do
      {:ok, game}
    else
      error -> error
    end
  end

  @spec hit?(Board.t(), non_neg_integer(), non_neg_integer()) :: :ok | {:error, :miss}
  def hit?(board, x, y) do
    case Board.get_position_value(board, x, y) do
      nil -> {:error, :miss}
      _ -> :ok
    end
  end

  @spec unique_shot?(Board.t(), non_neg_integer(), non_neg_integer()) ::
          :ok | {:error, :already_shot}
  def unique_shot?(board, x, y) do
    case Board.get_position_value(board, x, y) do
      nil -> :ok
      _ -> {:error, :already_shot}
    end
  end

  @spec in_bounds?(t, non_neg_integer(), non_neg_integer()) :: :ok | {:error, :out_of_bounds}
  def in_bounds?(game, x, y) do
    case x <= game.current_player.my_board.n and y <= game.current_player.my_board.n do
      true -> :ok
      false -> {:error, :out_of_bounds}
    end
  end
end
