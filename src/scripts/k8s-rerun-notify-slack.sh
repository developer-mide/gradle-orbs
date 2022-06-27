#!/bin/bash
./utilities/notify-slack.sh "${EMOJI} Running job \`${SERVICE_NAME}\` \`${CIRCLE_SHA1}\` (\`${CIRCLE_BRANCH}\`) in cluster ${CLUSTER_NAME}"

