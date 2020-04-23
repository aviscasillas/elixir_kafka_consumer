use Mix.Config

db_pool_size = System.get_env("DB_POOL_SIZE") |> String.to_integer

config :elixir_kafka_consumer, ElixirKafkaConsumer.Repo,
  database: System.get_env("DB_NAME"),
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST"),
  port: System.get_env("DB_PORT"),
  pool_size: db_pool_size

config :elixir_kafka_consumer, ecto_repos: [ElixirKafkaConsumer.Repo]

config :elixir_kafka_consumer, max_concurrency: db_pool_size

config :kaffe, consumer: [
  endpoints: System.get_env("BROKERS", "localhost:9092")
  |> String.split(",")
  |> Enum.map(&String.split(&1, ":"))
  |> Keyword.new(fn x ->
    {x |> Enum.at(0) |> String.to_atom,
     x |> Enum.at(1) |> String.trim |> String.to_integer}
  end),
  topics: System.get_env("TOPICS", "placeholder-topic") |> String.split(","),
  consumer_group: System.get_env("CONSUMER_GROUP"),
  message_handler: ElixirKafkaConsumer.Handler,
  start_with_earliest_message: true,
  max_bytes: 500_000
]

config :avrora,
  registry_url: System.get_env("REGISTRY_URL")
