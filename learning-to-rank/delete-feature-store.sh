#!/bin/bash
HOST="${1:-localhost}"

curl -s -X DELETE http://$HOST:9200/_ltr