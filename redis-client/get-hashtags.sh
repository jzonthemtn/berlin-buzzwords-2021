#!/bin/bash

docker-compose run redis-client redis-cli -h redis -p 6379 ZREVRANGEBYSCORE hashtags +inf -inf | head -n 1 | sed 's/[0-9])//g' | tr -d ' "' > hashtags
