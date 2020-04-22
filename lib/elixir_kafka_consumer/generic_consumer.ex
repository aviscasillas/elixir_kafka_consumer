defmodule ElixirKafkaConsumer.GenericConsumer do
  def handle_message(%{key: key, value: value} = message) do
    IO.inspect(message)

    with {:ok, decoded_value} <- decode(value) do
      IO.puts("#{key}: #{inspect(decoded_value)}")
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
