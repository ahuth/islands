defmodule IslandsEngine.GameTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Game, as: Subject

  setup do
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
  end
end
