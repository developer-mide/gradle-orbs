#!/bin/bash

# install dockerize
wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# wait for postgres to start
dockerize -wait tcp://postgres:5432 -timeout 2m

# Build all shadowDistTars
# Gradle automatically pushes this command upward and calls shadowDistTar in all projects from this
export CI_COMMIT_SHA="${CIRCLE_SHA1}"
export GIT_DESCRIBE=$(cat /tmp/workspace/git/describe)
gradle shadowDistTar --build-cache --parallel

# run
mkdir -p /tmp/workspace/shadow
cd /tmp/gradle-build/brace
find . -type f -name '*-shadow.tar' -exec cp '{}' /tmp/workspace/shadow ';'

# Persist DB utils shadowjar (FIXME)
mv /tmp/gradle-build/brace/database-test-utils/libs/* /tmp/workspace/shadow