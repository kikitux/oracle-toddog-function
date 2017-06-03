#!/usr/bin/env bash

docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
docker pull store/oracle/database-instantclient:12.2.0.1
docker build -t database-instantclient --rm .
