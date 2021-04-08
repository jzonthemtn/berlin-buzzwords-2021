#!/bin/bash
HOST="${1:-localhost}"
FEATURE_SET="${2:-more_movie_features}"

# See https://elasticsearch-learning-to-rank.readthedocs.io/en/latest/training-models.html

MODEL=`cat ../xgboost/xgb-model.json`

read -r -d '' BODY << EOM
{
  "model": {
    "name": "my_xgboost_model",
    "model": {
      "type": "model/xgboost+json",
      "definition": [
${MODEL}
      ]
    }
  }
}
EOM

curl -s -X POST http://$HOST:9200/_ltr/_featureset/$FEATURE_SET/_createmodel -H "Content-Type: application/json; charset=utf-8" --data "$BODY" | jq
