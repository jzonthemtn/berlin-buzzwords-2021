#!/bin/bash
HOST="${1:-localhost}"
INDEX="${2:-tmdb}"
ID="${3:-43004}"

read -r -d '' BODY << EOM
{"query":{ "ids":{ "values": [ $ID ] } } }
EOM

curl -s -X POST http://$HOST:9200/$INDEX/_search -H "Content-Type: application/json; charset=utf-8" --data "$BODY" | jq
