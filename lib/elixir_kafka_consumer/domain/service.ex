defmodule ElixirKafkaConsumer.Service do
  def process_record(record) do
    if record.body == nil do
      ElixirKafkaConsumer.Repo.delete_record(record)
    else
      ElixirKafkaConsumer.Repo.upsert_record(record)
    end
  end
end
