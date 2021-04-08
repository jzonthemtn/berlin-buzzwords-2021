#!/bin/bash
HOST="${1:-localhost}"
NAME="${2:-tmdb_features}"

curl -s -X GET http://$HOST:9200/_ltr/_featureset/$NAME | jq
