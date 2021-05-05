#!/bin/bash
docker-compose run mysql mysql -u root --password=password -h mysql < judgments.sql
