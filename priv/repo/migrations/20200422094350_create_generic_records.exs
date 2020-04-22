defmodule ElixirKafkaConsumer.Repo.Migrations.CreateGenericRecords do
  use Ecto.Migration

  def change do
    create table(:generic_records) do
      add :guid, :string, unique: true
      add :body, :map
    end
  end
end
