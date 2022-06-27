#!/bin/bash
kubectl wait --for=condition=complete --timeout ${TIMEOUT}m ${NAMESPACE}/${JOB_NAME} -n ${NAMESPACE}
