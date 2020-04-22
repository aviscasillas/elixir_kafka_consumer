defmodule ElixirKafkaConsumer.Repo.Migrations.CreateGenericRecords do
  use Ecto.Migration

  def change do
    create table(:generic_records) do
      add :guid, :string
      add :body, :map
    end

    create unique_index(:generic_records, [:guid])
  end
end
