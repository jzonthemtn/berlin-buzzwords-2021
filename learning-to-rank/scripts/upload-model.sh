#!/bin/bash
HOST="${1:-localhost}"

# See https://elasticsearch-learning-to-rank.readthedocs.io/en/latest/training-models.html

#MODEL=`cat model2.json`

curl -s -X POST http://$HOST:9200/_ltr/_featureset/more_movie_features/_createmodel -H "Content-Type: application/json; charset=utf-8" -d'
{
  "model": {
    "name": "my_xgboost_model",
    "model": {
      "type": "model/xgboost+json",
      "definition": [
  { "nodeid": 0, "depth": 0, "split": "tmdb_body", "split_condition": 11.2008772, "yes": 1, "no": 2, "missing": 1, "children": [
    { "nodeid": 1, "depth": 1, "split": "tmdb_title", "split_condition": 2.20630717, "yes": 3, "no": 4, "missing": 3, "children": [
      { "nodeid": 3, "leaf": -0.03125 },
      { "nodeid": 4, "leaf": -0.25 }
    ]},
    { "nodeid": 2, "leaf": 2.45000005 }
  ]},  { "nodeid": 0, "depth": 0, "split": "tmdb_title", "split_condition": 7.56361628, "yes": 1, "no": 2, "missing": 1, "children": [
    { "nodeid": 1, "depth": 1, "split": "tmdb_body", "split_condition": 11.2008772, "yes": 3, "no": 4, "missing": 3, "children": [
      { "nodeid": 3, "leaf": -0.0165441185 },
      { "nodeid": 4, "leaf": 0.0437499583 }
    ]},
    { "nodeid": 2, "leaf": 0.699999988 }
  ]}
]
    }
  }
}
' | jq
