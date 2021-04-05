#!/bin/bash

docker run \
  --env CONSUMER_KEY=$CONSUMER_KEY \
  --env CONSUMER_SECRET=$CONSUMER_SECRET \
  --env TOKEN=$TOKEN \
  --env TOKEN_SECRET=$TOKEN_SECRET \
  -it --rm jzemerick/flink-twitter:1.0
