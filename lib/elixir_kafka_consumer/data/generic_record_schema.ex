defmodule ElixirKafkaConsumer.GenericRecordSchema do
  use Ecto.Schema

  schema "generic_records" do
    field :guid, :string
    field :body, :map
  end
end
