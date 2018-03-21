defmodule IslandsEngine.BoardTest do
  use ExUnit.Case, async: true
  alias IslandsEngine.Board, as: Subject

  test "creating a new board" do
    assert Subject.new == %{}
  end
end
