defmodule ElixirKafkaConsumer.Service do
  alias ElixirKafkaConsumer.Repo, as: Repo

  def process_record(record) do
    if record.body == nil do
      Repo.delete_record(record)
    else
      Repo.upsert_record(record)
    end
  end
end
