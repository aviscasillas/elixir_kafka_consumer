defmodule ElixirKafkaConsumer.Handler do
  use Broadway

  alias ElixirKafkaConsumer.Service, as: Service
  alias ElixirKafkaConsumer.Record, as: Record

  @db_pool_size Application.fetch_env!(:elixir_kafka_consumer, :db_pool_size)
  @brokers Application.fetch_env!(:elixir_kafka_consumer, :brokers)
  @topics Application.fetch_env!(:elixir_kafka_consumer, :topics)
  @consumer_group Application.fetch_env!(:elixir_kafka_consumer, :consumer_group)

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          BroadwayKafka.Producer, [
            hosts: @brokers,
            group_id: @consumer_group,
            topics: @topics,
            max_bytes: 5_000_000
          ]},
        concurrency: 2
      ],
      processors: [
        default: [
          concurrency: @db_pool_size |> div(2)
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    message
    |> to_domain!
    |> Service.process_record

    message
  end

  defp to_domain!(message) do
    %Record{
      guid: message.metadata.key,
      body: message.data |> to_domain_value
    }
  end

  defp to_domain_value(value) do
    if value != "" do
      value |> sanitize |> avro_decode! |> Jason.decode!
    else
      nil
    end
  end

  defp sanitize(value) do
    value |> String.replace("\\u0000", "")
  end

  defp avro_decode!(value) do
    case Avrora.decode(value) do
      {:ok, decoded_value} ->  decoded_value
      _ -> value
    end
  end
end
