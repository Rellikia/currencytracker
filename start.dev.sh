#!/bin/bash

sh ./deploy/build.sh
docker-compose up -d db
docker-compose run app rails db:create db:migrate db:seed
docker-compose up -d