defmodule ElixirKafkaConsumer.Service do
  alias ElixirKafkaConsumer.Repo, as: Repo

  def delete_records(guids) do
    Repo.delete_all_records_by_guid(guids)
  end

  def upsert_records(records) do
    Repo.upsert_all_records(records)
  end
end
