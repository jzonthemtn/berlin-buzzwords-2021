#!/bin/bash

# Because this script repeatedly makes calls to Elasticsearch with a script to update
# document fields, Elasticsearch will eventually complain because of all the
# script compilations. As a workaround, add the following to the elasticsearch.yml:

# script.max_compilations_rate: 5000/1m

HOST="${1:-localhost}"
INDEX="${2:-tmdb}"
CATEGORY="christmas"

# Get all the indexed document IDs.
# TODO: Improve this. Can we get the IDs some other way or maybe just some subset of IDs?
LINE=`curl -s http://$HOST:9200/$INDEX/_search?pretty=true -H "Content-Type: application/json" -d '
{
    "from": 0,
    "size": 10000,
    "query" : {
        "match_all" : {}
    },
    "stored_fields": []
}
' | jq -r '.hits.hits[]._id' | tr '\n' ' '`

# An array of document IDs.
IDS=($LINE)

#echo "Document IDs:"
#printf '%s\n' "${IDS[@]}"

i=0

# For each document, pass the `overview` to the zero-shot classifier along with
# the given category. Then update the document to add a field called `classification_[category]`
# to the document with the predicted value.
for DOC_ID in "${IDS[@]}"
do

  echo "Classifying document ID $DOC_ID..."

  # Get the document text.
  OVERVIEW=`curl -s -X POST http://$HOST:9200/$INDEX/_search -H "Content-Type: application/json; charset=utf-8" --data "{\"query\":{ \"ids\":{ \"values\": [ $DOC_ID ] } } }" | jq -r .hits.hits[0]._source.overview  | tr -d '[:punct:]'`
  echo "Overview: $OVERVIEW"

  # Get the classification score for the document.
  CONFIDENCE=`curl -s -X POST http://localhost:8080/classify -d "{\"sequence\": \"$OVERVIEW\", \"labels\": [\"$CATEGORY\"]}" -H "Content-Type: application/json" | jq .scores[0]`
  echo "Confidence: $CATEGORY = $CONFIDENCE"

  echo "Updating document $DOC_ID for category $CATEGORY with value $CONFIDENCE"
  curl -X POST "http://$HOST:9200/$INDEX/_update/$DOC_ID" -H "Content-Type: application/json" --data "{\"script\" : \"ctx._source.classification_$CATEGORY = $CONFIDENCE\"}"

  echo "============================================="
  echo "$i of ${#IDS[@]}"
  ((i=i+1))
  echo "============================================="

done
