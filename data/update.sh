#!/bin/bash

HOST="${1:-localhost}"
INDEX="${2:-tmdb}"
DOC_ID="${2:-43004}"
CATEGORY="christmas"

CONFIDENCE=`curl -s -X POST http://localhost:8080/classify -d '{"sequence": "I want a cheeseburger.", "labels": ["christmas"]}' -H "Content-Type: application/json" | jq .scores[0]`

echo "Updating document $DOC_ID for category $CATEGORY with value $CONFIDENCE"

read -r -d '' BODY << EOM
{
  "script" : "ctx._source.classification_$CATEGORY = '$CONFIDENCE'"
}
EOM

curl -s -X POST "http://$HOST:9200/$INDEX/_update/$DOC_ID" -H "Content-Type: application/json" --data "$BODY" | jq
