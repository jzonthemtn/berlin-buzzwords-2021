#!/bin/bash
HOST="${1:-localhost}"
INDEX="${2:-tmdb}"

# This query for some reason doesn't return any results.

curl -s -X POST http://$HOST:9200/$INDEX/_search -H "Content-Type: application/json; charset=utf-8" -d'
{
    "query": {
        "match": {
            "_all": "rambo"
        }
    },
    "rescore": {
        "window_size": 1000,
        "query": {
            "rescore_query": {
                "sltr": {
                    "params": {
                        "keywords": "rambo"
                    },
                    "model": "my_xgboost_model"
                }
            }
        }
    }
}
' | jq
