#!/bin/bash

docker run -p 8080:8080 --env NLI_MODEL=facebook/bart-large-mnli -it jzemerick/bbuzz-zero-shot:1.0
