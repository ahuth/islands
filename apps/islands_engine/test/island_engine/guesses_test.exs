defmodule IslandsEngine.GuessesTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Guesses, as: Subject

  test "creating" do
    assert Subject.new == %Subject{hits: MapSet.new, misses: MapSet.new}
  end
end
