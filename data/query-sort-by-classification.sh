#!/bin/bash
HOST="${1:-localhost}"
INDEX="${2:-tmdb}"
TERM="${3:-christmas}"

read -r -d '' BODY << EOM
{
  "_source": true,
  "sort": [
    {
      "classification_$TERM" : {
        "order" : "desc"
      }
    }
  ],
  "query": {
    "match": {
      "genres": "Family"
    }
  }
}
EOM

curl -s -X POST http://$HOST:9200/$INDEX/_search -H "Content-Type: application/json; charset=utf-8" --data "$BODY" | jq


#,
#  "query": {
#    "bool": {
#      "must": [
#        {
#          "match": {
#            "genres": "Family"
#          }
#        },
#        {
#          "match": {
#            "overview": "$TERM"
#          }
#        }
#      ]
#    }
#  }
