#!/bin/bash
HOST="${1:-localhost}"

curl -s -X GET http://$HOST:9200/_ltr/_model/my_xgboost_model | jq
