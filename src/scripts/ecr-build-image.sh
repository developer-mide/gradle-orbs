#!/bin/bash
            HASH="git-${CIRCLE_SHA1}"
            GIT_DESCRIBE=$(cat /tmp/workspace/git/describe)
            TIMESTAMP_MS=$(date +%s000)
            MAIN_TAG=${REPOSITORY_URL}:${TAG_SUFFIX}
            HASH_TAG=${REPOSITORY_URL}:${HASH}
            docker build --target build-prod --tag dist:latest .
            docker build --target dist --tag ${MAIN_TAG} --build-arg build_version=${GIT_DESCRIBE} --build-arg build_timestamp=${TIMESTAMP_MS} .
            docker tag ${MAIN_TAG} ${HASH_TAG}
            aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${PW_STD_IN}
            docker push $MAIN_TAG
            docker push $HASH_TAG
