#!/bin/bash
node common/scripts/install-run-rush.js install
RUSH_BUILD_CACHE_CREDENTIAL=$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY node common/scripts/install-run-rush.js build -T @brace/borrower-frontend
