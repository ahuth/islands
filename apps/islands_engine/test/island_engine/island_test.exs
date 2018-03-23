defmodule IslandsEngine.IslandTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Coordinate
  alias IslandsEngine.Island, as: Subject

  describe "new/2" do
    setup do
      {:ok, coordinate} = Coordinate.new(1, 1)
      {:ok, %{origin: coordinate}}
    end

    test "squares", context do
      {:ok, island} = Subject.new(:square, context.origin)
      assert island.coordinates == MapSet.new([
        %Coordinate{row: 1, col: 1},
        %Coordinate{row: 1, col: 2},
        %Coordinate{row: 2, col: 1},
        %Coordinate{row: 2, col: 2},
      ])
    end

    test "atolls", context do
      {:ok, island} = Subject.new(:atoll, context.origin)
      assert island.coordinates == MapSet.new([
        %Coordinate{row: 1, col: 1},
        %Coordinate{row: 1, col: 2},
        %Coordinate{row: 2, col: 2},
        %Coordinate{row: 3, col: 1},
        %Coordinate{row: 3, col: 2},
      ])
    end

    test "dots", context do
      {:ok, island} = Subject.new(:dot, context.origin)
      assert island.coordinates == MapSet.new([
        %Coordinate{row: 1, col: 1},
      ])
    end

    test "L shapes", context do
      {:ok, island} = Subject.new(:l_shape, context.origin)
      assert island.coordinates == MapSet.new([
        %Coordinate{row: 1, col: 1},
        %Coordinate{row: 2, col: 1},
        %Coordinate{row: 3, col: 1},
        %Coordinate{row: 3, col: 2},
      ])
    end

    test "S shapes", context do
      {:ok, island} = Subject.new(:s_shape, context.origin)
      assert island.coordinates == MapSet.new([
        %Coordinate{row: 1, col: 2},
        %Coordinate{row: 1, col: 3},
        %Coordinate{row: 2, col: 1},
        %Coordinate{row: 2, col: 2},
      ])
    end

    test "invalid shapes result in an error", context do
      assert Subject.new(:foobar, context.origin) == {:error, :invalid_island_type}
    end

    test "invalid coordinates result in an error" do
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

  describe "overlaps?/2" do
    test "returns true when the islands overlap" do
      {:ok, square_coordinate} = Coordinate.new(1, 1)
      {:ok, dot_coordinate} = Coordinate.new(1, 2)
      {:ok, square} = Subject.new(:square, square_coordinate)
      {:ok, dot} = Subject.new(:dot, dot_coordinate)
      assert Subject.overlaps?(square, dot)
    end

    test "returns false when the islands do not overlap" do
      {:ok, square_coordinate} = Coordinate.new(1, 1)
      {:ok, l_shape_coordinate} = Coordinate.new(5, 5)
      {:ok, square} = Subject.new(:square, square_coordinate)
      {:ok, l_shape} = Subject.new(:l_shape, l_shape_coordinate)
      refute Subject.overlaps?(square, l_shape)
    end
  end
end
