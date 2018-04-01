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

    test "from initialized with add_player" do
      rules = Subject.new
      {:ok, rules} = Subject.check(rules, :add_player)
      assert rules == %Subject{state: :players_set}
    end

    test "from players_set with position_islands when the player is set" do
      rules = %Subject{state: :players_set, player1: :islands_set}
      assert Subject.check(rules, {:position_islands, :player1}) == :error
    end

    test "from players_set with position_islands when the player is not set" do
      rules = %Subject{state: :players_set, player1: :islands_not_set}
      {:ok, new_rules} = Subject.check(rules, {:position_islands, :player1})
      assert rules == new_rules
    end

    test "from players_set with set_islands when neither player is set" do
      rules = %Subject{state: :players_set, player1: :islands_not_set, player2: :islands_not_set}
      {:ok, rules} = Subject.check(rules, {:set_islands, :player1})
      assert rules.state == :players_set
      assert rules.player1 == :islands_set
    end

    test "from players_set with set_islands when both players end up set" do
      rules = %Subject{state: :players_set, player1: :islands_set, player2: :islands_not_set}
      {:ok, rules} = Subject.check(rules, {:set_islands, :player2})
      assert rules.state == :player1_turn
      assert rules.player2 == :islands_set
    end
  end
end
