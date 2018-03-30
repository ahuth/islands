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

    test "from players_set to position_islands when the player is set" do
      rules = %Subject{state: :players_set, player1: :islands_set}
      assert Subject.check(rules, {:position_islands, :player1}) == :error
    end

    test "from players_set to position_islands when the player is not set" do
      rules = %Subject{state: :players_set, player1: :islands_not_set}
      {:ok, new_rules} = Subject.check(rules, {:position_islands, :player1})
      assert rules == new_rules
    end
  end
end
