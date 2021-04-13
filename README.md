# Berlin Buzzwords 2021

As machine learning becomes more pervasive across industries the need to automate the deployment of the required infrastructure becomes even more important. The ability to efficiently and automatically provision infrastructure for modeling training, evaluation, and serving becomes an important component of a successful ML pipeline. Combined with the ever growing popularity of Kubernetes, a full-cycle, containerized method for managing models is needed.

In this talk we will present a containerized architecture to handle the full machine learning lifecycle of an NLP model. We will describe our technologies and tools used along with our lessons learned along the way. We will show how models can be trained, evaluated, and served in an automated fashion with room for extensibility to be customized for specific workloads.

Attendees of this talk will come away with a working knowledge of how a machine learning pipeline can be constructed and managed inside Kubernetes. Knowledge of NLP is not required. All code presented will be available on GitHub.

## Architecture

![Architecture](https://github.com/jzonthemtn/berlin-buzzwords-2021/blob/master/resources/arch.png?raw=true)

## Usage

In the commands below, `localhost` is where Elasticsearch is running and `tmdb` is the name of the index.

1. Run `docker-compose build`
2. Create a `twitter.env` file with your Twitter credentials like:

```
CONSUMER_KEY=
CONSUMER_SECRET=
TOKEN=
TOKEN_SECRET=
```

3. Run `docker-compose up`
4. Index movie documents in Elasticsearch:

```
cd data/
./index.sh localhost tmdb
```

To see a few indexed documents run: `./data/query.sh`

At this point, you have the following containers running:

* `flink-twitter` - Capturing counts of hashtags and persisting those counts in Redis.
* `elasticsearch` - Elasticsearch.
* `classifier` - A zero-shot learning classifier exposed through a REST service.
* `redis` - Cache for storing hashtags and counts.

The Apache Flink job will be running and capturing hashtags and their counts. The hashtags and their counts will be sorted and the most frequently occurring hashtags and their counts will be persisted to the Redis cache.

**This step needs implemented ----->** Read the trending hashtags from Redis.

Now, update the indexed documents (movies) with a field containing the classifier's score for the hashtag. In the example commands below, the hashtag is `christmas`. This command updates all of the indexed documents by passing each document's (movie) summary to the zero-shot classifier along with the category (hashtag `christmas`). The result is a value between 0 and 1 indicating how well the model thinks the movie summary matches the category. (For example, the movie "Jingle all the Way" will likely get a score greater than 0.9 while the movie "Space Jam" will receive a much lower score.) A new field called `classification_christmas` is added to each document containing the value.

```
cd data/
./update.sh localhost tmdb christmas
```

Now when we search we can sort the results descending by the `classification_christmas` field. Use the command below to run a search:

```
./data/query-sort-by-classification.sh localhost tmdb christmas
```

The command above searches for movies matching the `Family` genre and sorts them by the `classification_christmas` field. This gives us a list of family movies with Christmas movies returned first. "Jingle all the Way" will be returned much earlier in the search results than "Space Jam."

### Model Training

The `nli` directory contains files needed to fine-tune a NLI model on BERT using the MNLI dataset. If you want to change the parameters of the training modify the `train.sh` script. Change to the `nli` directory and run `build.sh` to build the image.

Now run the docker image to start training using the `run.sh` script. Model artifacts will be written to `./models/`.
