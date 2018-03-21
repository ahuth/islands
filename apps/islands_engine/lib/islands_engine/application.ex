defmodule IslandsEngine.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: IslandsEngine.Worker.start_link(arg)
      # {IslandsEngine.Worker, arg},
    ]

    opts = [strategy: :one_for_one, name: IslandsEngine.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
