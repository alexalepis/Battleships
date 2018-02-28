defmodule Place do

    @orientation {:vertical, :horizontal}

    def custom(ship, board, x, y, orientation) do

        with true <- in_bounds?(ship, board, x, y, orientation),
             true <- free_position?(ship, board, x, y, orientation),
             true <- Enum.any?(board.map, fn{_, value}-> value!={ship.id} end) 
        do
            {:ok, Board.place_ship(ship, board, x, y, orientation)}
        else
            false -> {:error, board}
        end
    end

    def random(ship, {:ok, %Board{}=board}), do: random( ship, {:ok, %Board{}=board}, 0)
    def random(_, {:error, board}),          do: {:error, board}

    defp random(_, {_, board}, 100),    do: {:error, board}
    defp random(_, {:error, board}, _), do: {:error, board}
    defp random(ship, {:ok, %Board{}=board}, fail_cnt) do

        with x = rand(board.n - ship.length),
             y = rand(board.n - ship.length),
             orientation = elem(@orientation, rand(2)-1),
             true <- in_bounds?(ship, board, x, y, orientation),
             true <- free_position?(ship, board, x, y, orientation)
        do
            {:ok, Board.place_ship(ship, board, x, y, orientation)}
        else
            false -> random(ship, {:ok, %Board{}=board}, fail_cnt + 1)
        end
    end

    def in_bounds?(ship, board, x, y, :horizontal ), do: x + ship.length <= board.n 
    def in_bounds?(ship, board, x, y, :vertical   ), do: y + ship.length <= board.n 
    
    def free_position?(ship, board, x, y, :horizontal) do
        x..ship.length + x - 1
        |> Enum.all?(fn(x) -> Board.get_position_value(board, x, y)=={:no_value} end)
    end
    def free_position?(ship, board, x, y, :vertical) do
        y..ship.length + y - 1
        |> Enum.all?(fn(y) -> Board.get_position_value(board, x, y)=={:no_value} end)
    end

    defp rand(n) when n<=0, do: 1
    defp rand(n), do: :rand.uniform(n)

end