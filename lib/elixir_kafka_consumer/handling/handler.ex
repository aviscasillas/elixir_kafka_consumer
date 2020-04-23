defmodule ElixirKafkaConsumer.Handler do
  def handle_messages(messages) do
    messages
    |> Enum.reverse
    |> Enum.uniq_by(fn msg -> msg.key end)
    |> Enum.each(fn msg ->
      msg
      |> to_domain!
      |> ElixirKafkaConsumer.Service.process_record
    end)

    :ok
  end

  defp to_domain!(%{key: key, value: value}) do
    %ElixirKafkaConsumer.Record{guid: key, body: value |> to_domain_value}
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
