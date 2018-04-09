defmodule IslandsEngine.RulesTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Rules, as: Subject

  test "creating" do
    assert Subject.new == %Subject{state: :initialized}
  end

  describe "check/2" do
    test "unknown states" do
      rules = %Subject{state: :not_real}
      assert Subject.check(rules, :add_player) == :error
    end

    test "unknown actions" do
      rules = Subject.new
      assert Subject.check(rules, :foobar) == :error
    end

    test "progressing through each state" do
      # Initial state
      rules = Subject.new
      assert rules == %Subject{state: :initialized, player1: :islands_not_set, player2: :islands_not_set}
      # Start the game
      {:ok, rules} = Subject.check(rules, :add_player)
      assert rules == %Subject{state: :players_set, player1: :islands_not_set, player2: :islands_not_set}
      # Position an island
      {:ok, rules} = Subject.check(rules, {:position_islands, :player1})
      assert rules == %Subject{state: :players_set, player1: :islands_not_set, player2: :islands_not_set}
      # Position an island
      {:ok, rules} = Subject.check(rules, {:position_islands, :player2})
      assert rules == %Subject{state: :players_set, player1: :islands_not_set, player2: :islands_not_set}
      # Player one sets her islands
      {:ok, rules} = Subject.check(rules, {:set_islands, :player1})
      assert rules == %Subject{state: :players_set, player1: :islands_set, player2: :islands_not_set}
      # Player one can no longer position islands
      result = Subject.check(rules, {:position_islands, :player1})
      assert result == :error
      # Player two can still position islands
      {:ok, rules} = Subject.check(rules, {:position_islands, :player2})
      assert rules == %Subject{state: :players_set, player1: :islands_set, player2: :islands_not_set}
      # Player two sets her islands and the next state is reached
      {:ok, rules} = Subject.check(rules, {:set_islands, :player2})
      assert rules == %Subject{state: :player1_turn, player1: :islands_set, player2: :islands_set}
      # Player two tries to guess, but it's not her turn
      result = Subject.check(rules, {:guess_coordinate, :player2})
      assert result == :error
      # Player one guesses
      {:ok, rules} = Subject.check(rules, {:guess_coordinate, :player1})
      assert rules == %Subject{state: :player2_turn, player1: :islands_set, player2: :islands_set}
      # Player two guesses
      {:ok, rules} = Subject.check(rules, {:guess_coordinate, :player2})
      assert rules == %Subject{state: :player1_turn, player1: :islands_set, player2: :islands_set}
      # Player one guesses
      {:ok, rules} = Subject.check(rules, {:guess_coordinate, :player1})
      assert rules == %Subject{state: :player2_turn, player1: :islands_set, player2: :islands_set}
      # Check for a win when it's not yet over
      {:ok, rules} = Subject.check(rules, {:win_check, :no_win})
      assert rules == %Subject{state: :player2_turn, player1: :islands_set, player2: :islands_set}
      # Check for a win when it is over
      {:ok, rules} = Subject.check(rules, {:win_check, :win})
      assert rules == %Subject{state: :game_over, player1: :islands_set, player2: :islands_set}
    end
  end
end
