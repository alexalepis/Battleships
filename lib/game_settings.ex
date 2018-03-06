defmodule Game.Settings do
  @moduledoc """
      Game settings creates the basic settings of each game
  """
  defstruct [:board, :random_place, :fleet]

  @type t :: %__MODULE__{board: Board.t(), random_place: any(), fleet: Fleet.t()}

  def new(board_size \\ 5, random_place \\ true, default_fleet \\ true) do
    game_settings = %Game.Settings{board: Board.new(board_size), random_place: random_place}

    case default_fleet do
      true -> %{game_settings | fleet: Fleet.default_fleet()}
      _ -> %{game_settings | fleet: nil}
    end
  end

  @spec add_fleet(t, Fleet.t()) :: t
  def add_fleet(game_settings, fleet) do
    %{game_settings | fleet: fleet}
  end
end
