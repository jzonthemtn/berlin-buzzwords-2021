#!/bin/bash

curl -X POST http://localhost:8080/classify -d '{"sequence": "I want a cheeseburger.", "labels": ["politics", "lunch", "baseball"]}' -H "Content-Type: application/json"
