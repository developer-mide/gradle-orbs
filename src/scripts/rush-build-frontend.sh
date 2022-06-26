#!/bin/bash
BUILD_DATE="$(date)"
export BUILD_TIME_STAMP=$BUILD_DATE
TMP_WORKSPACE_GIT_DESCRIBE=$(cat /tmp/workspace/git/describe)
export GIT_DESCRIBE=$TMP_WORKSPACE_GIT_DESCRIBE
RUSH_BUILD_CACHE_CREDENTIAL=$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY node common/scripts/install-run-rush.js build -t @brace/borrower-frontend -t @brace/servicer --verbose
echo "${GIT_DESCRIBE}" > ./clients/borrower-frontend/build/version
echo "${GIT_DESCRIBE}" > ./clients/servicer/build/version
echo "" > ./clients/servicer/build/service-worker.js
