#!/bin/bash

mvn -f ./flink-twitter/pom.xml clean install
mvn -f ./score-calculator/pom.xml clean install

export CLOUDSDK_PYTHON=/usr/bin/python
docker-compose build
