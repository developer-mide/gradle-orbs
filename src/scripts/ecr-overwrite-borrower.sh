#!/bin/bash
            cd /tmp/workspace/borrower || exit
            tar -zcf ${ARCHIVE_NAME} build
            aws s3 cp ${ARCHIVE_NAME} s3://${ARCHIVE_BUCKET}/borrower/${ARCHIVE_NAME}
