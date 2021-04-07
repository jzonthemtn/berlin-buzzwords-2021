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

## TODO

Now we need to read the hashtags from Redis and use those as candidate categories for the zero-shot classifier. The text being classified will be the `overview` for each indexed movie document. The confidence values will be used as a feature value to train the model.

An example being:

```
4 qid:1 1:90.584847
3 qid:1 1:75.695847
```

The query id `1` corresponds to the `christmas` query.

Use this judgments file to train an xgboost model. Upload the model to Elasticsearch. Run a `family` search and see that the movie search results are now ranked based on the trending hashtags, e.g. `christmas`.

Resources:

* https://xgboost.readthedocs.io/en/latest/tutorials/input_format.html
* https://elasticsearch-learning-to-rank.readthedocs.io/en/latest/core-concepts.html

### Open Questions


## Architecture

![Architecture](https://github.com/jzonthemtn/berlin-buzzwords-2021/blob/master/resources/arch.png?raw=true)
