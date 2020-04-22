defmodule ElixirKafkaConsumer.GenericConsumer do
  def handle_message(%{key: key, value: value}) do
    with {:ok, decoded_value} <- decode(value) do
      if decoded_value |> tombstone? do
        record = ElixirKafkaConsumer.Repo.get_by(ElixirKafkaConsumer.GenericRecord, guid: key)
        if record != nil do
          ElixirKafkaConsumer.Repo.delete!(record)
        end
      else
        %ElixirKafkaConsumer.GenericRecord{guid: key, body: decoded_value |> Poison.decode!}
        |> ElixirKafkaConsumer.Repo.insert(on_conflict: :replace_all, conflict_target: :guid)
      end

      :ok
    else
      err -> err
    end
  end

  defp decode(value) do
    case Avrora.decode(value)  do
      {:ok, decoded_value} -> {:ok, decoded_value}
      {:error, :undecodable} -> {:ok, value}
      _ -> {:error, :decode_error}
    end
  end

  defp tombstone?(value) do
    value == ""
  end
end
