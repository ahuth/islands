defmodule IslandsEngine.Rules do
  alias __MODULE__

  defstruct state: :initialized,
            player1: :island_not_set,
            player2: :island_not_set

  def new, do: %Rules{}

  def check(%Rules{state: :initialized} = rules, :add_player), do: {:ok, %Rules{rules | state: :players_set}}
  def check(%Rules{state: :players_set} = rules, {:position_islands, player}) do
    case Map.fetch!(rules, player) do
      :islands_set -> :error
      :islands_not_set -> {:ok, rules}
    end
  end
  def check(_, _), do: :error
end
