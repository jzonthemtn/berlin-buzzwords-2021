#!/bin/bash

curl -s -X POST http://localhost:8080/classify -d '{"sequence": "I like eating cheeseburgers.", "labels": ["politics", "lunch", "baseball"]}' -H "Content-Type: application/json" | jq
