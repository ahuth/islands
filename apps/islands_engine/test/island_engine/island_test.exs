defmodule IslandsEngine.IslandTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Coordinate
  alias IslandsEngine.Island, as: Subject

  @origin %Coordinate{row: 1, col: 1}

  test "creating a valid square" do
    {:ok, island} = Subject.new(:square, @origin)
    assert island.coordinates == MapSet.new([
      %Coordinate{row: 1, col: 1},
      %Coordinate{row: 1, col: 2},
      %Coordinate{row: 2, col: 1},
      %Coordinate{row: 2, col: 2},
    ])
  end

  test "creating a valid atoll" do
    {:ok, island} = Subject.new(:atoll, @origin)
    assert island.coordinates == MapSet.new([
      %Coordinate{row: 1, col: 1},
      %Coordinate{row: 1, col: 2},
      %Coordinate{row: 2, col: 2},
      %Coordinate{row: 3, col: 1},
      %Coordinate{row: 3, col: 2},
    ])
  end

  test "creating a valid dot" do
    {:ok, island} = Subject.new(:dot, @origin)
    assert island.coordinates == MapSet.new([
      %Coordinate{row: 1, col: 1},
    ])
  end

  test "creating a valid L shape" do
    {:ok, island} = Subject.new(:l_shape, @origin)
    assert island.coordinates == MapSet.new([
      %Coordinate{row: 1, col: 1},
      %Coordinate{row: 2, col: 1},
      %Coordinate{row: 3, col: 1},
      %Coordinate{row: 3, col: 2},
    ])
  end

  test "creating a valid S shape" do
    {:ok, island} = Subject.new(:s_shape, @origin)
    assert island.coordinates == MapSet.new([
      %Coordinate{row: 1, col: 2},
      %Coordinate{row: 1, col: 3},
      %Coordinate{row: 2, col: 1},
      %Coordinate{row: 2, col: 2},
    ])
  end

  test "creating an invalid shape" do
    assert Subject.new(:foobar, @origin) == {:error, :invalid_island_type}
  end

  test "creating with an invalid coordinate" do
    assert Subject.new(:square, %Coordinate{row: 10, col: 5}) == {:error, :invalid_coordinate}
  end

  test "offsetting from the coordinate" do
    {:ok, island} = Subject.new(:square, %Coordinate{row: 4, col: 6})
    assert island.coordinates == MapSet.new([
      %Coordinate{row: 4, col: 6},
      %Coordinate{row: 4, col: 7},
      %Coordinate{row: 5, col: 6},
      %Coordinate{row: 5, col: 7},
    ])
  end
end
