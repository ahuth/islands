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
end
