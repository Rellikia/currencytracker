#!/bin/bash

envApplication='development'
project='[DEV]currencytracker'
dockerfilePath='../Dockerfile'
containerName='currencytracker'
containerRepository=''
clusterName=''

. ./deploy-common.sh

docker-compose up -d