#!/bin/bash

ENV_SELECTED=$1

ACR_NAME="acrCurrencytracker"
USER="acrcurrencytracker.azurecr.io"

APP="currencytracker"
APP_DOCKERFILE="Dockerfile"

WEB="nginx"
WEB_DOCKERFILE="Dockerfile-nginx"

TIMESTAMP=$(date "+%Y.%m.%d-%H.%M")


echo "[APP] Construindo a imagem ${USER}/${APP}:${TIMESTAMP}"
docker build -t ${USER}/${APP}:${TIMESTAMP} -f ${APP_DOCKERFILE} .

echo "[APP] Marcando a tag latest também"
docker tag ${USER}/${APP}:${TIMESTAMP} ${USER}/${APP}:latest

if [ "${ENV_SELECTED}" = "production" ]
then
  echo "[APP] Enviando a imagem para nuvem docker"
  az acr login --name ${ACR_NAME}
  docker push ${USER}/${APP}:${TIMESTAMP}
  docker push ${USER}/${APP}:latest
else
  echo "[APP] Imagem não enviada para a nuvem docker"
fi


echo "\n[WEB] Construindo a imagem ${USER}/${WEB}:${TIMESTAMP}"
docker build -t ${USER}/${WEB}:${TIMESTAMP} -f ${WEB_DOCKERFILE} .

echo "[WEB] Marcando a tag latest também"
docker tag ${USER}/${WEB}:${TIMESTAMP} ${USER}/${WEB}:latest

if [ "${ENV_SELECTED}" = "production" ]
then
  echo "[WEB] Enviando a imagem para nuvem docker"
  az acr login --name ${ACR_NAME}
  docker push ${USER}/${WEB}:${TIMESTAMP}
  docker push ${USER}/${WEB}:latest
else
  echo "[WEB] Imagem não enviada para a nuvem docker"
fi

export TIMESTAMP