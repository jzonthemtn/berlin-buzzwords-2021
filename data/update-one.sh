#!/bin/bash

HOST="${1:-localhost}"
INDEX="${2:-tmdb}"

CATEGORY="christmas"
DOC_ID="238302"

echo "Classifying document ID $DOC_ID..."

# Get the document text.
OVERVIEW=`curl -s -X POST http://$HOST:9200/$INDEX/_search -H "Content-Type: application/json; charset=utf-8" --data "{\"query\":{ \"ids\":{ \"values\": [ $DOC_ID ] } } }" | jq -r .hits.hits[0]._source.overview | tr -d '[:punct:]'`
echo "Overview: $OVERVIEW"

# Get the classification score for the document.
CONFIDENCE=`curl -s -X POST http://localhost:8080/classify -d "{\"sequence\": \"$OVERVIEW\", \"labels\": [\"$CATEGORY\"]}" -H "Content-Type: application/json" | jq .scores[0]`
echo "Confidence: $CATEGORY = $CONFIDENCE"

echo "Updating document $DOC_ID for category $CATEGORY with value $CONFIDENCE"
curl -X POST "http://$HOST:9200/$INDEX/_update/$DOC_ID" -H "Content-Type: application/json" --data "{\"script\" : \"ctx._source.classification_$CATEGORY = $CONFIDENCE\"}"
