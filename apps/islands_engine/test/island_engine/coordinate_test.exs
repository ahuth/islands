defmodule IslandsEngine.CoordinateTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Coordinate, as: Subject

  test "creating" do
    assert Subject.new(5, 5) == {:ok, %Subject{row: 5, col: 5}}
  end

  test "out of bounds row" do
    assert Subject.new(-1, 5) == {:error, :invalid_coordinate}
  end

  test "out of bounds col" do
    assert Subject.new(5, 11) == {:error, :invalid_coordinate}
  end
end
