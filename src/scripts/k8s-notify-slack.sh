#!/bin/bash
./utilities/notify-slack.sh "${EMOJI} Deploying \`${CIRCLE_SHA1}\` (\`${CIRCLE_BRANCH}\`) to ${SERVICE_NAME} in cluster ${CLUSTER_NAME}"
