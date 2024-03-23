# q2a-docker

Stack is deployment for [Question?Answer](https://docs.question2answer.org/) platform. Only configuration
is [setenv.sh](./setenv.sh) with 3 environment properties for Q2A DB connection:

* QA_DB_USER
* QA_DB_PASS
* QA_DB_NAME

## Services

### q2a-web

Build by [q2a.dockerfile](./q2a.dockerfile) FROM php:7.2-apache.

### mysql:5

MySql DB used by Q2A. Root password is logged into server console.
MYSQL_RANDOM_ROOT_PASSWORD: 'yes'

Check ```docker service logs {stack_name}_mysqldb```

## Install

* configure [setenv.sh](./setenv.sh) properties
* (optionally) if you customize image uncomment docker.sh build line, or in case you do not like to download docker
  image [mara14/q2a-web](https://hub.docker.com/r/mara14/q2a-web)
* run [docker.sh](./docker.sh) with docker stack deploy command. The docker container needs to be in swarm
  mode (```docker swarm init```).