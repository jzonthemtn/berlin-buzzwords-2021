#!/bin/bash
HOST="${1:-localhost}"
NAME="${2:-my_xgboost_model}"

curl -s -X GET http://$HOST:9200/_ltr/_model/$NAME | jq
