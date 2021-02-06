#!/bin/bash

kubectl create secret docker-registry gcr --docker-server=eu.gcr.io  --docker-username=_json_key --docker-password="$(cat read_only.json)"
kubectl patch sa default -p '{"imagePullSecrets":[{"name":"gcr"}]}'
sleep 5

tos profile import profile | tos profile reload
sleep 5

kubectl delete pods --all
