#!/bin/bash

envApplication='production'
project='[PRODUCTION]currencytracker'
dockerfilePath='../Dockerfile'
containerName='currencytracker'
containerRepository='225519998962.dkr.ecr.us-east-2.amazonaws.com'
clusterName='prod-currencytracker'

. ./deploy-common.sh --stop-tasks --upload-image --login