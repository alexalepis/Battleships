defmodule Player do
  @moduledoc """
    Player is responsible for all action concerning the player creation-initialization, changes and ship placement strategy.
  """

  defstruct [:id, :name, :my_board, :shot_board, :enemy_fleet]

  @opaque p :: %Player{
            id: any(),
            name: any(),
            my_board: Board.t(),
            shot_board: Board.t(),
            enemy_fleet: Fleet.t()
          }
  @type t :: %__MODULE__{}
  @doc """
  Creates a new player putting the values given as parameters to a struct, which it returns.
  """
  @spec new(id :: any(), name :: any(), Board.t(), Fleet.t()) :: p
  def new(id, name, board, fleet) do
    %Player{id: id, name: name, my_board: board, shot_board: board, enemy_fleet: fleet}
  end

  @spec place_random(p) :: p
  def place_random(player) do
    player.enemy_fleet.ships
    |> Enum.reduce({:ok, player.my_board}, fn ship, board -> Board.place_random(ship, board) end)
    |> is_placed(player)
  end

  @doc """
  Given a player's struct, a ship, coordinates (x and y) and orientation, place_custom /5
  places the given players ship on the given player's board accoring to the coordinates and orientation.
  """
  @spec place_custom(p, Ship.t(), integer(), integer(), atom()) :: p
  def place_custom(player, ship, x, y, orientation) do
    player =
      Board.place_custom(ship, player.my_board, x, y, orientation)
      |> is_placed(player)
  end

  @doc """
  Checks if the result of the placement of the ship is successful and returns an :error and the board, or :ok and the board accordingly.
  """
  @spec is_placed({:error, any()} | {:ok, Board.t()}, p) :: p
  def is_placed(place_result, player) do
    case place_result do
      {:error, _} ->
        IO.puts("Error placement")
        player

      {:ok, board} ->
        %{player | my_board: board}
    end
  end
end
