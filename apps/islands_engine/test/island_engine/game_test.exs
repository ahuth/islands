defmodule IslandsEngine.GameTest do
  use ExUnit.Case, async: false
  alias IslandsEngine.Game, as: Subject
  alias IslandsEngine.Rules

  setup do
    on_exit fn ->
      :ets.delete_all_objects(:game_state)
    end

    {:ok, game} = Subject.start_link("Wilma")
    %{game: game}
  end

  test "starting", %{game: game} do
    state = :sys.get_state(game)
    assert state.player1.name == "Wilma"
  end

  test "naming", %{game: game} do
    :ok = Subject.add_player(game, "Fred")
    state = :sys.get_state(game)
    assert state.player2.name == "Fred"
  end

  test "positioning", %{game: game} do
    :ok = Subject.add_player(game, "Fred")
    state = :sys.get_state(game)
    refute Map.has_key?(state.player1.board, :square)

    :ok = Subject.position_island(game, :player1, :square, 1, 1)
    state = :sys.get_state(game)
    assert Map.has_key?(state.player1.board, :square)

    assert Subject.position_island(game, :player1, :dot, 1, 1) == {:error, :overlapping_island}
  end

  test "setting", %{game: game} do
    :ok = Subject.add_player(game, "Fred")
    assert Subject.set_islands(game, :player1) == {:error, :not_all_islands_positioned}

    :ok = Subject.position_island(game, :player1, :atoll, 1, 1)
    :ok = Subject.position_island(game, :player1, :dot, 1, 4)
    :ok = Subject.position_island(game, :player1, :l_shape, 1, 5)
    :ok = Subject.position_island(game, :player1, :s_shape, 5, 1)
    :ok = Subject.position_island(game, :player1, :square, 5, 5)
    {:ok, _} = Subject.set_islands(game, :player1)

    state = :sys.get_state(game)
    assert state.rules.player1 == :islands_set
    assert state.rules.state == :players_set
  end

  test "guessing", %{game: game} do
    :ok = Subject.add_player(game, "Fred")
    assert Subject.guess_coordinate(game, :player1, 1, 1) == :error

    :ok = Subject.position_island(game, :player1, :dot, 1, 1)
    :ok = Subject.position_island(game, :player2, :square, 1, 4)

    :sys.replace_state(game, fn data ->
      %{data | rules: %Rules{state: :player1_turn}}
    end)

    assert Subject.guess_coordinate(game, :player1, 5, 5) == {:miss, :none, :no_win}
    assert Subject.guess_coordinate(game, :player1, 5, 5) == :error
    assert Subject.guess_coordinate(game, :player2, 1, 1) == {:hit, :dot, :win}
  end
end
