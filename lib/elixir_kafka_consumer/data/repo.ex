defmodule ElixirKafkaConsumer.Repo do
  use Ecto.Repo,
    otp_app: :elixir_kafka_consumer,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query

  alias ElixirKafkaConsumer.GenericRecordSchema, as: GenericRecordSchema

  def delete_all_records_by_guid(guids) do
    from(r in GenericRecordSchema, where: r.guid in ^guids)
    |> delete_all
  end

  def upsert_all_records(records) do
    insert_all(
      GenericRecordSchema,
      records |> Enum.map(fn r -> %{guid: r.guid, body: r.body} end),
      on_conflict: :replace_all,
      conflict_target: :guid
    )
  end
end
