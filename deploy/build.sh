#!/bin/bash

USER="danielalvarenga"

APP="currencytracker"
APP_DOCKERFILE="Dockerfile"

WEB="nginx"
WEB_DOCKERFILE="Dockerfile-nginx"

TIMESTAMP=$(date "+%Y.%m.%d-%H.%M")


echo "[APP] Construindo a imagem ${USER}/${APP}:${TIMESTAMP}"
docker build -t ${USER}/${APP}:${TIMESTAMP} -f ${APP_DOCKERFILE} .

echo "[APP] Marcando a tag latest também"
docker tag ${USER}/${APP}:${TIMESTAMP} ${USER}/${APP}:latest

echo "[APP] Enviando a imagem para nuvem docker... INTERROMPIDO"
#docker push ${USER}/${APP}:${TIMESTAMP}
#docker push ${USER}/${APP}:latest


echo "[WEB] Construindo a imagem ${USER}/${WEB}:${TIMESTAMP}"
docker build -t ${USER}/${WEB}:${TIMESTAMP} -f ${WEB_DOCKERFILE} .

echo "[WEB] Marcando a tag latest também"
docker tag ${USER}/${WEB}:${TIMESTAMP} ${USER}/${WEB}:latest

echo "[WEB] Enviando a imagem para nuvem docker... INTERROMPIDO"
#docker push ${USER}/${WEB}:${TIMESTAMP}
#docker push ${USER}/${WEB}:latest

export TIMESTAMP