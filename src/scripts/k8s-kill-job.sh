#!/bin/bash
ACTIVE=$(kubectl get jobs -n jobs ${NAME} -o jsonpath='{.status}' | jq '.active')
[[ "${ACTIVE}" == "null" ]] && { echo "${NAME} is not active: exiting." ; exit 0; }
kubectl patch job -n jobs ${NAME} -p '{"spec":{"parallelism":0}}'
./utilities/notify-slack.sh ":burning-moneybag: Killing unfinished \`${NAME}\` job."
