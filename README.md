# Berlin Buzzwords 2021

## Usage

1. Run `docker-compose build`
2. Create a `twitter.env` file with your Twitter credentials like:

```
CONSUMER_KEY=
CONSUMER_SECRET=
TOKEN=
TOKEN_SECRET=
```

3. Run `docker-compose up`
4. Index movies into Elasticsearch:

```
cd data/es-tmdb/
./index.sh
```

To see some indexed documents run: `./scripts/query.sh`

At this point, you have the following containers running:

* `flink-twitter` - Capturing counts of hashtags and persisting those counts in Redis.
* `elasticsearch` - Elasticsearch with indexed movie documents.
* `classifier` - A zero-shot learning classifier exposed through a REST service.
* `redis` - Cache for storing hashtags and counts.

The Apache Flink job will be running and capturing hashtags and their counts. The hashtags and their counts will be sorted and the most frequently occurring hashtags and their counts will be persisted to the Redis cache.

## Architecture

![Architecture](https://github.com/jzonthemtn/berlin-buzzwords-2021/blob/master/resources/arch.png?raw=true)
