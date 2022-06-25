#!/bin/bash
export BUILD_TIME_STAMP="`date`"
export GIT_DESCRIBE=$(cat /tmp/workspace/git/describe)
RUSH_BUILD_CACHE_CREDENTIAL=$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY node common/scripts/install-run-rush.js build -t @brace/borrower-frontend -t @brace/servicer --verbose
echo "${GIT_DESCRIBE}" > ./clients/borrower-frontend/build/version
echo "${GIT_DESCRIBE}" > ./clients/servicer/build/version
echo "" > ./clients/servicer/build/service-worker.js
