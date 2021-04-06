#!/bin/bash
HOST="${1:-localhost}"

curl -s -X POST http://$HOST:9200/_search -H "Content-Type: application/json; charset=utf-8" -d'
{
  "query": {
    "bool": {
      "filter": [
        {
          "terms": {
            "_id": [
              "7555",
              "1370",
              "1369"
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
