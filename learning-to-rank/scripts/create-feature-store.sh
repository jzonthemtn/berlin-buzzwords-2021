#!/bin/bash
HOST="${1:-localhost}"

curl -s -X PUT http://$HOST:9200/_ltr | jq
