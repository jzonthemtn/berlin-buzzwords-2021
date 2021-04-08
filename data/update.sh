#!/bin/bash

HOST="${1:-localhost}"
INDEX="${2:-tmdb}"
CATEGORY="christmas"

# Get all the indexed document IDs.
LINE=`curl -s http://$HOST:9200/$INDEX/_search?pretty=true -H "Content-Type: application/json" -d '
{
    "from": 0,
    "size": 10000,
    "query" : {
        "match_all" : {}
    },
    "stored_fields": []
}
' | jq -r '.hits.hits[]._id'   | tr '\n' ' '`

IDS=($LINE)

#echo "Document IDs:"
#printf '%s\n' "${IDS[@]}"

i=0

for DOC_ID in "${IDS[@]}"
do

  echo "Classifying document ID $DOC_ID..."

  # Get the document text.
  OVERVIEW=`curl -s -X POST http://$HOST:9200/$INDEX/_search -H "Content-Type: application/json; charset=utf-8" --data "{\"query\":{ \"ids\":{ \"values\": [ $DOC_ID ] } } }" | jq -r .hits.hits[0]._source.overview`
  echo "Overview: $OVERVIEW"

  # Get the classification score for the document.
  CONFIDENCE=`curl -s -X POST http://localhost:8080/classify -d "{\"sequence\": \"$OVERVIEW\", \"labels\": [\"$CATEGORY\"]}" -H "Content-Type: application/json" | jq .scores[0]`
  echo "Confidence: $CATEGORY = $CONFIDENCE"

  echo "Updating document $DOC_ID for category $CATEGORY with value $CONFIDENCE"
  curl -s -X POST "http://$HOST:9200/$INDEX/_update/$DOC_ID" -H "Content-Type: application/json" --data "{\"script\" : \"ctx._source.classification_$CATEGORY = '$CONFIDENCE'\"}" > /dev/null

  echo "============================================="
  echo "$i of ${#IDS[@]}"
  ((i=i+1))
  echo "============================================="

done