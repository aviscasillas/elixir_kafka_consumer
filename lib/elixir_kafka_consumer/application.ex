defmodule ElixirKafkaConsumer.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      ElixirKafkaConsumer.Repo,
      Avrora,
      worker(Kaffe.Consumer, [])
    ]
    opts = [strategy: :one_for_one, name: ElixirKafkaConsumer.GenericConsumer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
