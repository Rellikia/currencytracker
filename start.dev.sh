#!/bin/bash

./deploy/build.sh
docker-compose run app rails db:create db:migrate db:seed
docker-compose up -d