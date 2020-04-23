# ElixirKafkaConsumer

> This is just a project to play a bit with Elixir and see how it feels consuming from Kafka.

A generic, **non-blocking**, Kafka consumer implemented on top of [Kaffe](https://github.com/spreedly/kaffe), [Avrora](https://github.com/Strech/avrora) and [ecto](https://github.com/elixir-ecto/ecto).

## What?
**A generic implementation of a Kafka consumer:**
1. Grab messages from a given kafka topic.
2. Update `GenericRecord` entity state in the DB.

**It works under some assumptions:**
- The given Kafka topic represents an entity and is configured with `compaction` strategy.
- Message `key` is the unique identifier of the given entity.
- Message `value` is the entity attributes serialised as JSON.


## Install
``` bash
git clone https://github.com/aviscasillas/elixir_kafka_consumer.git
cd elixir_kafka_consumer
mix deps.get

# Setup ENV variables to fit your needs
cp .env.local.sample .env.local
```

## Run
```bash
# Startup postgres database
docker-compose up
```

``` bash
local-exec mix ecto.create
local-exec mix ecto.migrate
```

``` bash
local-exec mix run --no-halt
```

