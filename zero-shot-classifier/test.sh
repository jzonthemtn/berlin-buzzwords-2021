#!/bin/bash

#curl -s -X POST http://localhost:8080/classify -d '{"sequence": "I like eating cheeseburgers.", "labels": ["politics", "lunch", "baseball"]}' -H "Content-Type: application/json" | jq

# When running in kserving:
curl -v http://localhost:8080/v1/models/zero-shot-classifier:predict -d @./input.json
#curl -v http://localhost:8080/v1/models/zero-shot-classifier:predict -d '{"sequence": "I like eating cheeseburgers.", "labels": ["politics", "lunch", "baseball"]}' -H "Content-Type: application/json"
