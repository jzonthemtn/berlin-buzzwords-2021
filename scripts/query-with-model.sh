#!/bin/bash
HOST="${1:-localhost}"
INDEX="${2:-tmdb}"

# you almost certainly don’t want to run sltr this way :)
# In reality you would never want to use the sltr query this way.
# Why? This model executes on every result in your index. These models are CPU intensive.
# You’ll quickly make your Elasticsearch cluster crawl with the query above.
# https://elasticsearch-learning-to-rank.readthedocs.io/en/latest/searching-with-your-model.html

curl -s -X POST http://$HOST:9200/$INDEX/_search -H "Content-Type: application/json; charset=utf-8" -d'
{
  "query": {
    "sltr": {
      "params": {
        "keywords": "rambo"
      },
      "model": "my_xgboost_model"
    }
  }
}
' | jq
