defmodule IslandsEngine.Coordinate do
  alias __MODULE__

  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_range 1..10

  def new(row, col) when not(row in @board_range and col in @board_range) do
    {:error, :invalid_coordinate}
  end

  def new(row, col) do
    {:ok, %Coordinate{row: row, col: col}}
  end
end
