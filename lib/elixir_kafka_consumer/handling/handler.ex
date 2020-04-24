defmodule ElixirKafkaConsumer.Handler do
  use Broadway

  alias Broadway.Message, as: Message
  alias ElixirKafkaConsumer.Service, as: Service
  alias ElixirKafkaConsumer.Record, as: Record

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
            max_bytes: 500_000,
            # `after_fetch` callback added in a personal fork:
            # => https://github.com/aviscasillas/broadway_kafka
            after_fetch: fn(messages) ->
              messages
              |> Enum.reverse
              |> Enum.uniq_by(&(&1.metadata.key))
              |> Enum.reverse
            end
          ]},
        concurrency: 4
      ],
      processors: [
        default: [
          concurrency: 100
        ]
      ],
      batchers: [
        delete_records: [
          batch_size: 1000,
          batch_timeout: 200,
          concurrency: 50
        ],
        upsert_records: [
          batch_size: 1000,
          batch_timeout: 200,
          concurrency: 50
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    message
    |> Message.update_data(fn data -> decode(data) end)
    |> process_message
  end

  defp process_message(%Message{} = message) do
    # Determine which batcher gets the message.
    case message.data do
      nil -> message |> Message.put_batcher(:delete_records)
      _ -> message |> Message.put_batcher(:upsert_records)
    end
  end

  @impl true
  def handle_batch(:delete_records, messages, _, _) do
    messages
    |> Enum.map(fn msg -> msg.metadata.key end)
    |> Service.delete_records

    messages
  end

  @impl true
  def handle_batch(:upsert_records, messages, _, _) do
    messages
    |> Enum.map(&to_domain!(&1))
    |> Service.upsert_records

    messages
  end

  defp to_domain!(message) do
    %Record{
      guid: message.metadata.key,
      body: message.data
    }
  end

  defp decode(value) do
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
