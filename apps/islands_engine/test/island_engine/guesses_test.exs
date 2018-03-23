defmodule IslandsEngine.GuessesTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Coordinate
  alias IslandsEngine.Guesses, as: Subject

  test "creating" do
    assert Subject.new == %Subject{hits: MapSet.new, misses: MapSet.new}
  end

  test "adding a hit" do
    {:ok, coordinate} = Coordinate.new(8, 3)
    guesses = Subject.new |> Subject.add(:hit, coordinate)
    assert guesses.hits == MapSet.new([coordinate])
  end

  test "adding a miss" do
    {:ok, coordinate} = Coordinate.new(9, 7)
    guesses = Subject.new |> Subject.add(:miss, coordinate)
    assert guesses.misses == MapSet.new([coordinate])
  end
end
