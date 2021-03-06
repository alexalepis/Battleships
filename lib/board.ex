defmodule Board do
  @moduledoc """
    Board creates and manipulates the playing boards
  """

  defstruct [:map, :n]
  @orientation {:vertical, :horizontal}

  @type t :: %__MODULE__{map: map(), n: integer()}
  @doc """
    Creates a new board sized sz x sz, containing the coordinates of each place on the board as the key and an atom :no_value as value. 
  """
  @spec new(non_neg_integer()) :: t
  def new(n) do
    %Board{map: Map.new(), n: n}
  end

  @doc """
    Takes a board, an x and an y as parameters and returns the value of the position (x,y) in the board. 
  """
  @spec get_position_value(t, non_neg_integer(), non_neg_integer()) ::
          tuple() | atom() | integer() | nil
  def get_position_value(board, x, y) do
    board.map
    |> Map.get({x, y})
  end

  @doc """
    Replaces the value with the key {x, y} of the board given, with the value given.
  """
  @spec replace_value(t, non_neg_integer, non_neg_integer, value :: integer() | tuple()) :: t
  def replace_value(board, x, y, value) do
    new_map =
      board.map
      |> Map.replace!({x, y}, value)

    %{board | map: new_map}
  end

  @doc """
    Indicates the hit ships that have been hit on all the places they have been placed as sunk.   
  """
  @spec replace_values(t, integer()) :: t
  def replace_values(board, ship_id) do
    new_map =
      Enum.reduce(board.map, %{}, fn
        {key, {:hit, id}}, acc ->
          if id == ship_id do
            Map.put(acc, key, {:sunk, ship_id})
          else
            Map.put(acc, key, {:hit, id})
          end

        {key, value}, acc ->
          Map.put(acc, key, value)
      end)

    %{board | map: new_map}
  end

  @doc """
    Adds a key-value pair of the format: "{x,y} => value" to the given map.
  """
  @spec add_value(t, non_neg_integer(), non_neg_integer(), integer() | atom() | tuple()) :: t
  def add_value(board, x, y, value) do
    new_map =
      board.map
      |> Map.put_new({x, y}, value)

    %{board | map: new_map}
  end

  @doc """
    Takes a board, an x, a y and a value as parameters and returns the board having replaced the value at the position (x,y) with the given value. 
  """
  @spec place_ship(Ship.t(), t, non_neg_integer(), non_neg_integer(), atom()) :: t
  def place_ship(ship, board, x, y, :horizontal) do
    x..(ship.length + x - 1)
    |> Enum.reduce(board, fn x, board -> add_value(board, x, y, ship.id) end)
  end

  def place_ship(ship, board, x, y, :vertical) do
    y..(ship.length + y - 1)
    |> Enum.reduce(board, fn y, board -> add_value(board, x, y, ship.id) end)
  end

  @doc """
    Custom ship Placement
  """
  @spec place_custom(Ship.t(), t, non_neg_integer(), non_neg_integer(), atom()) ::
          {:ok, t} | {:error, t}
  def place_custom(ship, board, x, y, orientation) do
    with true <- in_bounds?(ship, board, x, y, orientation),
         true <- is_not_placed?(ship, board),
         true <- free_position?(ship, board, x, y, orientation) do
      {:ok, place_ship(ship, board, x, y, orientation)}
    else
      false -> {:error, board}
    end
  end

  @doc """
    Random ship Placement
  """
  @spec place_random(Ship.t(), {:ok | :error, Board.t()}) :: {:error, Board.t()} | Board.t()
  def place_random(ship, {:ok, %Board{} = board}),
    do: place_random(ship, {:ok, %Board{} = board}, 0)

  def place_random(_, {:error, board}), do: {:error, board}

  @spec place_random(Ship.t(), {:ok | :error, Board.t()}, integer()) ::
          {:error, Board.t()} | Board.t()
  defp place_random(_, {_, board}, 100), do: {:error, board}
  # defp place_random(_, {:error, board}, _), do: {:error, board}
  defp place_random(ship, {:ok, %Board{} = board}, fail_cnt) do
    with x = rand(board.n - ship.length),
         y = rand(board.n - ship.length),
         orientation = elem(@orientation, rand(2) - 1),
         true <- in_bounds?(ship, board, x, y, orientation),
         true <- is_not_placed?(ship, board),
         true <- free_position?(ship, board, x, y, orientation) do
      {:ok, place_ship(ship, board, x, y, orientation)}
    else
      false -> place_random(ship, {:ok, %Board{} = board}, fail_cnt + 1)
    end
  end

  @doc """
    Checks if the ship given has not already been placed on the board given. Returns true if the ship is OK to be placed.
  """

  @spec is_not_placed?(Ship.t(), t) :: boolean()
  def is_not_placed?(ship, board) do
    case Enum.any?(board.map, fn {_, value} -> value == ship.id end) do
      true -> false
      false -> true
    end
  end

  @doc """
    Checks if the ship fits in the board taking in account the coordinates given and it's orientation. 
  """
  @spec in_bounds?(Ship.t(), t, integer(), integer(), atom()) :: boolean()
  def in_bounds?(ship, board, x, _, :horizontal), do: x + ship.length <= board.n
  def in_bounds?(ship, board, _, y, :vertical), do: y + ship.length <= board.n

  @doc """
    Checks if the position the ship is wanted to be placed in, is filled by another ship or not.
  """
  @spec free_position?(Ship.t(), t, integer(), integer(), atom()) :: boolean()
  def free_position?(ship, board, x, y, :horizontal) do
    x..(ship.length + x - 1)
    |> Enum.all?(fn x -> get_position_value(board, x, y) == nil end)
  end

  def free_position?(ship, board, x, y, :vertical) do
    y..(ship.length + y - 1)
    |> Enum.all?(fn y -> get_position_value(board, x, y) == nil end)
  end

  @spec rand(integer()) :: integer()
  defp rand(n) when n <= 0, do: 1
  defp rand(n), do: :rand.uniform(n)
end
