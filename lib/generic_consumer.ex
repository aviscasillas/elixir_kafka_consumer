defmodule GenericConsumer do
  def handle_message(%{key: key, value: value} = message) do
    IO.inspect(message)

    decoded_value = Avrora.decode(value)

    IO.puts("#{key}: #{inspect(decoded_value)}")
    :ok
  end
end
