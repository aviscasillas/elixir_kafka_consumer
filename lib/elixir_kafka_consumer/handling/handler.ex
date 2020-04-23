defmodule ElixirKafkaConsumer.Handler do
  alias ElixirKafkaConsumer.Service, as: Service
  alias ElixirKafkaConsumer.Record, as: Record

  @max_concurrency Application.fetch_env!(:elixir_kafka_consumer, :max_concurrency)

  def handle_messages(messages) do
    messages
    |> Enum.reverse
    |> Enum.uniq_by(&(&1.key))
    |> Task.async_stream(__MODULE__, :handle_message, [], max_concurrency: @max_concurrency)
    |> Stream.run

    :ok
  end

  def handle_message(message) do
    message
    |> to_domain!
    |> Service.process_record
  end

  defp to_domain!(%{key: key, value: value}) do
    %Record{guid: key, body: value |> to_domain_value}
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
