#!/bin/bash

. ./setenv.sh
docker build -t mara14/q2a-web:latest -f q2a.dockerfile .
#docker push mara14/q2a-web:latest
docker stack deploy -c docker-compose.yml q2a_stack

