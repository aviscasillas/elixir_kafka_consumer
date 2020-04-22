# ElixirKafkaConsumer

This is just a project to play a bit with Elixir and see how it feels consuming from Kafka.

It's a generic implementation of a Kafka consumer that:
1. Grabs messages from a given kafka topic.
2. Updates the corresponding entity state in a DB.

**NOTE:** This implementation goes under the assumptions listed below: 
- The topic represents an entity.
- The entity is identified by the message `key`.
- The entity body is represented by the message `value`.
- The topic is configured with `compaction` strategy.
- The data is stored in a Postgres database.


## Installation

``` bash
git clone https://github.com/aviscasillas/elixir_kafka_consumer.git
cd elixir_kafka_consumer
mix deps.get
cp .env.local.sample .env.local # Update ENV variables tha fit your needs
```

## Running it locally

``` bash
# Startup postgres database
docker-compose up

# It will open an iex console and run the consumer using the .env.local environment
local-run
```

