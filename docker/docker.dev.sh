#!/bin/bash

envApplication='development'
project='[DEV]currencytracker'
dockerfilePath='../Dockerfile'
containerName='currencytracker'
containerRepository=''
clusterName=''

. ./deploy-common.sh

docker-compose up -d db
docker-compose run app rails db:create db:migrate db:seed
docker-compose up -d