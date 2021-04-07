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


## Directories

* `flink-twitter` - Consumes Twitter stream to find trending hashtags over a rolling window. Includes a Docker image.

* `helm-charts` - Cloned from https://github.com/elastic/helm-charts.git. Cloned because have to use a custom Docker container that includes the Elasticsearch LTR plugin.

* `learning-to-rank` - Scripts to work with learning-to-rank models.

* `zero-shot-classifier` - Code and Docker image for a zero-shot classifier. Runs as a REST service.

## Architecture

![Architecture](https://github.com/jzonthemtn/berlin-buzzwords-2021/blob/master/resources/arch.png?raw=true)
