defmodule ElixirKafkaConsumer.Application do
  use Application

  def start(_type, _args) do
    children = [
      ElixirKafkaConsumer.Repo,
      Avrora,
      %{
        id: Kaffe.GroupMemberSupervisor,
        start: {Kaffe.GroupMemberSupervisor, :start_link, []},
        type: :supervisor
      }
    ]

    opts = [strategy: :one_for_one, name: ElixirKafkaConsumer.GenericConsumer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
