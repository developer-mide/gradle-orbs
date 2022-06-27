#!/bin/bash
kubectl get job -n jobs "<< parameters.job_name >>" -o json | \
jq 'del(.spec.template.metadata.labels)' | \
jq 'del(.spec.selector)' | \
jq '.spec.parallelism=1' | \
kubectl replace --force -f -
