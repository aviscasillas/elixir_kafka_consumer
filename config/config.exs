use Mix.Config

config :elixir_kafka_consumer, ElixirKafkaConsumer.Repo,
  database: System.get_env("DB_NAME"),
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST"),
  port: System.get_env("DB_PORT")

config :elixir_kafka_consumer, ecto_repos: [ElixirKafkaConsumer.Repo]

config :kaffe, consumer: [
  endpoints: System.get_env("BROKERS", "localhost:9092")
  |> String.split(",")
  |> Enum.map(fn x -> String.split(x, ":") end)
  |> Keyword.new(fn x ->
    {x |> Enum.at(0) |> String.to_atom,
     x |> Enum.at(1) |> String.trim |> String.to_integer}
  end),
  topics: System.get_env("TOPICS", "placeholder-topic") |> String.split(","),
  consumer_group: System.get_env("CONSUMER_GROUP"),
  message_handler: GenericConsumer,
  start_with_earliest_message: true
]

config :avrora,
  registry_url: System.get_env("REGISTRY_URL")
