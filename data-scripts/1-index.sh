#!/bin/bash

HOST="${1:-localhost}"
INDEX="${2:-tmdb}"

# Unzip the movies to a temp directory.
unzip -o tmdb_es.json.zip -d /tmp/tmdb_es

# Delete the index if it exists.
curl -X DELETE "http://$HOST:9200/$INDEX"

# Create the index.
curl -X PUT "http://$HOST:9200/$INDEX/" -H "Content-Type: application/json" --data-binary @schema.json

# Index the movies.
curl -X POST "http://$HOST:9200/$INDEX/_bulk" -H "Content-Type: application/json" --data-binary @/tmp/tmdb_es/tmdb_es.json
