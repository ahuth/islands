defmodule IslandsEngine.BoardTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.{Coordinate, Island}
  alias IslandsEngine.Board, as: Subject

  test "creating a new board" do
    assert Subject.new == %{}
  end

  describe "position_island/3" do
    test "successfully adding an island" do
      {:ok, coord} = Coordinate.new(5, 5)
      {:ok, island} = Island.new(:square, coord)
      board = Subject.new
      board = Subject.position_island(board, :square, island)
      assert Map.fetch!(board, :square) == island
    end

    test "does not add an overlapping island" do
      {:ok, coord} = Coordinate.new(5, 5)
      {:ok, dot} = Island.new(:dot, coord)
      {:ok, l_shape} = Island.new(:l_shape, coord)
      board = Subject.new
      board = Subject.position_island(board, :dot, dot)
      assert Subject.position_island(board, :l_shape, l_shape) == {:error, :overlapping_island}
    end
  end

  describe "all_islands_positioned/1" do
    test "indicates if all islands have been positioned" do
      board = Subject.new
      refute Subject.all_islands_positioned?(board)

      {:ok, coord} = Coordinate.new(1, 1)
      {:ok, square} = Island.new(:square, coord)
      board = Subject.position_island(board, :square, square)
      refute Subject.all_islands_positioned?(board)

      {:ok, coord} = Coordinate.new(10, 10)
      {:ok, dot} = Island.new(:dot, coord)
      board = Subject.position_island(board, :dot, dot)
      refute Subject.all_islands_positioned?(board)

      {:ok, coord} = Coordinate.new(3, 1)
      {:ok, l_shape} = Island.new(:l_shape, coord)
      board = Subject.position_island(board, :l_shape, l_shape)
      refute Subject.all_islands_positioned?(board)

      {:ok, coord} = Coordinate.new(6, 1)
      {:ok, s_shape} = Island.new(:s_shape, coord)
      board = Subject.position_island(board, :s_shape, s_shape)
      refute Subject.all_islands_positioned?(board)

      {:ok, coord} = Coordinate.new(4, 6)
      {:ok, atoll} = Island.new(:atoll, coord)
      board = Subject.position_island(board, :atoll, atoll)
      assert Subject.all_islands_positioned?(board)
    end
  end
end
