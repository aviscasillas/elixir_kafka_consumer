defmodule ElixirKafkaConsumer.Repo do
  use Ecto.Repo,
    otp_app: :elixir_kafka_consumer,
    adapter: Ecto.Adapters.Postgres
end
