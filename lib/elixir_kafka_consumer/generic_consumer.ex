defmodule ElixirKafkaConsumer.GenericConsumer do
  def handle_message(%{key: key, value: value} = message) do
    with {:ok, decoded_value} <- decode(value) do
      %ElixirKafkaConsumer.GenericRecord{guid: key, body: decoded_value |> Poison.decode!}
      |> ElixirKafkaConsumer.Repo.insert

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
end
