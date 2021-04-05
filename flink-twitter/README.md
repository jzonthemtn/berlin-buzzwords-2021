# Flink-Twitter Consumer

This project is a Flink consumer for tweets that tracks the top hashtags over a 5 minute rolling window.

To run, first build the image.

```
docker build -t jzemerick/flink-twitter:1.0 .
```

Next, run the image and provide a set of valid Twitter credentials.

```
docker run \
  --env CONSUMER_KEY=$CONSUMER_KEY \
  --env CONSUMER_SECRET=$CONSUMER_SECRET \
  --env TOKEN=$TOKEN \
  --env TOKEN_SECRET=$TOKEN_SECRET \
  -it --rm jzemerick/flink-twitter:1.0
```

This project was originally based on https://github.com/erikbeebe/flink_twitter_topN.
