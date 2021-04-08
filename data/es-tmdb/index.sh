#!/bin/bash

HOST="${1:-localhost}"
INDEX="${2:-tmdb}"

if [ ! -f ./tmdb_es.json ]; then
  unzip tmdb_es.json.zip
fi

# Delete and create the index.
curl -X DELETE "http://$HOST:9200/$INDEX"
curl -X PUT "http://$HOST:9200/$INDEX/" -H "Content-Type: application/json" --data-binary @schema.json

# Index the movies.
curl -X POST "http://$HOST:9200/$INDEX/_bulk" -H "Content-Type: application/json" --data-binary @tmdb_es.json

rm tmdb_dump_2020-12-29.json
rm tmdb_es.json
