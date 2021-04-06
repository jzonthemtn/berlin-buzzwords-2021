#!/bin/bash

. ../twitter.env

REDIS_HOST="redis"

docker run \
  --env CONSUMER_KEY=$CONSUMER_KEY \
  --env CONSUMER_SECRET=$CONSUMER_SECRET \
  --env TOKEN=$TOKEN \
  --env TOKEN_SECRET=$TOKEN_SECRET \
  --env REDIS_HOST=$REDIS_HOST \
  -it --rm jzemerick/bbuzz-flink-twitter:1.0
