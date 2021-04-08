#!/bin/bash

HOST="${1:-localhost}"
INDEX="${2:-tmdb}"

if [ ! -f ./tmdb_es.json ]; then
  unzip tmdb_es.json.zip
fi

curl -XDELETE "http://$HOST:9200/$INDEX";
curl -XPUT "http://$HOST:9200/$INDEX/" -H 'Content-Type: application/json' --data-binary @schema.json
curl -XPOST "http://$HOST:9200/$INDEX/_bulk" -H 'Content-Type: application/json' --data-binary @tmdb_es.json
