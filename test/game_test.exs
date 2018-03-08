defmodule GameTest do
  use ExUnit.Case
  doctest Battleships

  test "play round" do
    game_settings = Game.Settings.new()
    game = Game.new(1, game_settings)
    game = Game.add_player(game, 1, "pl1")
    game = Game.add_player(game, 2, "pl2")

    player =
      Player.place_custom(
        game.current_player,
        Enum.at(game.current_player.enemy_fleet.ships, 1),
        1,
        1,
        :vertical
      )

    player =
      Player.place_custom(
        player,
        Enum.at(game.current_player.enemy_fleet.ships, 2),
        2,
        1,
        :vertical
      )

    player =
      Player.place_custom(
        player,
        Enum.at(game.current_player.enemy_fleet.ships, 0),
        3,
        1,
        :vertical
      )

    game = %{game | current_player: player}

    player2 =
      Player.place_custom(
        game.enemy_player,
        Enum.at(game.enemy_player.enemy_fleet.ships, 0),
        1,
        1,
        :horizontal
      )

    player2 =
      Player.place_custom(
        player2,
        Enum.at(game.enemy_player.enemy_fleet.ships, 1),
        1,
        2,
        :horizontal
      )

    player2 =
      Player.place_custom(
        player2,
        Enum.at(game.enemy_player.enemy_fleet.ships, 2),
        1,
        3,
        :horizontal
      )

    game = %{game | enemy_player: player2}

    ship_to_hit_id = Board.get_position_value(game.enemy_player.my_board, 1, 1)

    ship_to_hit =
      Enum.find(game.enemy_player.enemy_fleet.ships, fn x -> x.id == ship_to_hit_id end)

    {:ok, game, :no_winner} = Game.make_move(game, 1, 1)

    assert Board.get_position_value(game.current_player.my_board, 1, 1) == {:hit, 3}
    assert Board.get_position_value(game.enemy_player.shot_board, 1, 1) == :hit

    ship_hit = Enum.find(game.enemy_player.enemy_fleet.ships, fn x -> x.id == ship_to_hit_id end)

    assert ship_hit.length == ship_to_hit.length - 1

    ship_to_hit_id = Board.get_position_value(game.enemy_player.my_board, 1, 1)

    ship_to_hit =
      Enum.find(game.enemy_player.enemy_fleet.ships, fn x -> x.id == ship_to_hit_id end)

    {:ok, game, :no_winner} = Game.make_move(game, 1, 1)

    assert Board.get_position_value(game.current_player.my_board, 1, 1) == {:hit, 2}
    assert Board.get_position_value(game.enemy_player.shot_board, 1, 1) == :hit

    ship_hit = Enum.find(game.enemy_player.enemy_fleet.ships, fn x -> x.id == ship_to_hit_id end)

    assert ship_hit.length == ship_to_hit.length - 1
  end
end
