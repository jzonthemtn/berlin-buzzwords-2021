#!/bin/bash
HOST="${1:-localhost}"
INDEX="${2:-tmdb}"

curl -s -X POST http://$HOST:9200/$INDEX/_search -H "Content-Type: application/json; charset=utf-8" -d'
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "genres": "Family"
          }
        },
        {
          "match": {
            "overview": "christmas"
          }
        }
      ]
    }
  }
}
' | jq
