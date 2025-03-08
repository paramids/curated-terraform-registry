#!/usr/bin/env sh

if [ -z "${GOOGLE_CLOUD_PROJECT}" ]; then
    echo 'The GOOGLE_CLOUD_PROJECT environment variable that points to the default Google Cloud project is not defined. Terminating...'
    return 
fi

export GOOGLE_CLOUD_REGION=europe-west1
export GOOGLE_CLOUD_ZONE=europe-west1-b
export TF_SERVICE_ACCOUNT_NAME=tf-service-account
export TF_STATE_PROJECT=${GOOGLE_CLOUD_PROJECT}
export TF_STATE_BUCKET=tf-state-bucket-${TF_STATE_PROJECT}

