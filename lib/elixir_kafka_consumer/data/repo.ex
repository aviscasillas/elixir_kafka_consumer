defmodule ElixirKafkaConsumer.Repo do
  use Ecto.Repo,
    otp_app: :elixir_kafka_consumer,
    adapter: Ecto.Adapters.Postgres

  alias ElixirKafkaConsumer.GenericRecordSchema, as: GenericRecordSchema

  def delete_record(record) do
    generic_record = get_by(GenericRecordSchema, guid: record.guid)
    if generic_record != nil do delete!(record) end
  end

  def upsert_record(record) do
    %GenericRecordSchema{guid: record.guid, body: record.body}
    |> insert(on_conflict: :replace_all, conflict_target: :guid)
  end
end
