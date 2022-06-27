#!/bin/bash
kubectl rollout status deployment/${SERVICE_NAME}-${ENV_NAME} -n ${SERVICE_NAME} --timeout ${TIMEOUT}m
