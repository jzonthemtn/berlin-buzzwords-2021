FROM ubuntu:20.04

# Install package dependencies
RUN apt-get update && apt-get -y install python3 curl build-essential

# Install python requirements
RUN apt-get install -y python3-pip
RUN python3 -m pip install --no-cache-dir xgboost
