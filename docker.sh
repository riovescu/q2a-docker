#!/bin/bash

. ./setenv.sh
docker build -t riovescu/q2a-web:latest -f q2a.dockerfile .
#docker push riovescu/q2a-web:latest
docker stack deploy -c docker-compose.yml q2a_stack

