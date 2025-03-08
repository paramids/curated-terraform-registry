#!/usr/bin/env sh

if command -v terraform >/dev/null 2>&1; then
  cd terraform/
  echo "Clean up resources created by terraform."
  if terraform destroy -auto-approve ; then
    if gsutil ls -b gs://"${TF_STATE_BUCKET}" >/dev/null 2>&1; then
      echo "Delete ${TF_STATE_BUCKET} Google Cloud Storage bucket."
      gsutil rm -r gs://${TF_STATE_BUCKET}
    fi
  fi
  cd ../
else
  echo "Terraform is not install in the environment, re-run clean up from an environment with terraform installed."
fi
