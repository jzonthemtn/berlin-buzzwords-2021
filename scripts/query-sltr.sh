#!/bin/bash
HOST="${1:-localhost}"
INDEX="${2:-tmdb}"

# The sltr uses a hook in the search to generate the feature values.
# The ext part of the query turns on feature logging so the values are included in the response.

curl -s -X POST http://$HOST:9200/$INDEX/_search -H "Content-Type: application/json; charset=utf-8" -d'
{
  "query": {
    "bool": {
      "filter": [
        {
          "terms": {
            "_id": [
              "7555"
            ]
          }
        },
        {
          "sltr": {
            "_name": "logged_featureset",
            "featureset": "more_movie_features",
            "params": {
              "keywords": "rambo"
            }
          }
        }
      ]
    }
  },
  "ext": {
    "ltr_log": {
        "log_specs": {
            "name": "log_entry1",
            "named_query": "logged_featureset"
        }
    }
  }
}
' | jq
