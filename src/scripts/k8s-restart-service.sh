#!/bin/bash
kubectl rollout restart -n "${SERVICE_NAME}" deployment/"${SERVICE_NAME}"-${CLUSTER_NAME}
