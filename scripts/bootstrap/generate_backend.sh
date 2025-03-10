#!/usr/bin/env sh


# Check if the necessary dependencies are available
if ! command -v gsutil >/dev/null 2>&1; then
    echo "gsutil command is not available, but it's needed. Terminating..."
    return
fi

if [ -z "${TF_SERVICE_ACCOUNT_NAME}" ]; then
    echo 'The TF_SERVICE_ACCOUNT_NAME environment variable that points to the Google Cloud service account that Terraform will use is not defined. Terminating...'
    return
fi

if [ -z "${TF_STATE_PROJECT}" ]; then
    echo 'The TF_STATE_PROJECT environment variable that points to the Google Cloud project to store the Terraform state is not defined. Terminating...'
    return
fi

if [ -z "${TF_STATE_BUCKET}" ]; then
    echo 'The TF_STATE_BUCKET environment variable that points to the Google Cloud Storage bucket to store the Terraform state is not defined. Terminating...'
    return
fi

if [ -z "${GOOGLE_CLOUD_PROJECT}" ]; then
    echo 'The GOOGLE_CLOUD_PROJECT environment variable that points to the default Google Cloud project that Terraform will provision the resources in is not defined. Terminating...'
    return
fi

if [ -z "${GOOGLE_CLOUD_REGION}" ]; then
    echo 'The GOOGLE_CLOUD_REGION environment variable that points to the default Google Cloud region that Terraform will provision the resources in is not defined. Terminating...'
    return
fi

if [ -z "${GOOGLE_CLOUD_ZONE}" ]; then
    echo 'The GOOGLE_CLOUD_ZONE environment variable that points to the default Google Cloud zone that Terraform will provision the resources in is not defined. Terminating...'
    return
fi

echo "Setting the default Google Cloud project to ${TF_STATE_PROJECT}"
gcloud config set project "${TF_STATE_PROJECT}"

echo "Creating the service account for Terraform"
if gcloud iam service-accounts describe "${TF_SERVICE_ACCOUNT_NAME}"@"${TF_STATE_PROJECT}".iam.gserviceaccount.com >/dev/null 2>&1; then
    echo "The ${TF_SERVICE_ACCOUNT_NAME} service account already exists."
else
    gcloud iam service-accounts create "${TF_SERVICE_ACCOUNT_NAME}" \
        --display-name "Terraform admin account"
fi

echo "Granting the service account permission to view the Admin Project"
gcloud projects add-iam-policy-binding "${TF_STATE_PROJECT}" \
    --member serviceAccount:"${TF_SERVICE_ACCOUNT_NAME}"@"${TF_STATE_PROJECT}".iam.gserviceaccount.com \
    --role roles/viewer

echo "Granting the service account permission to view the Admin Project"
gcloud projects add-iam-policy-binding "${TF_STATE_PROJECT}" \
    --member serviceAccount:"${TF_SERVICE_ACCOUNT_NAME}"@"${TF_STATE_PROJECT}".iam.gserviceaccount.com \
    --role roles/viewer

echo "Enable the Cloud Resource Manager API with"
gcloud services enable cloudresourcemanager.googleapis.com


echo "Creating a new Google Cloud Storage bucket to store the Terraform state in ${TF_STATE_PROJECT} project, bucket: ${TF_STATE_BUCKET}"
if gsutil ls -b gs://"${TF_STATE_BUCKET}" >/dev/null 2>&1; then
    echo "The ${TF_STATE_BUCKET} Google Cloud Storage bucket already exists."
else
    gsutil mb -p "${TF_STATE_PROJECT}" gs://"${TF_STATE_BUCKET}"
    gsutil versioning set on gs://"${TF_STATE_BUCKET}"
fi

TERRAFORM_BACKEND_DESCRIPTOR_PATH=terraform/backend.tf
echo "Generating the descriptor to hold backend data in ${TERRAFORM_BACKEND_DESCRIPTOR_PATH}"
if [ -f "${TERRAFORM_BACKEND_DESCRIPTOR_PATH}" ]; then
    echo "The ${TERRAFORM_BACKEND_DESCRIPTOR_PATH} file already exists."
else
    tee "${TERRAFORM_BACKEND_DESCRIPTOR_PATH}" <<EOF
# This is an automatically generated file. DO NOT MODIFY
terraform {
    backend "gcs" {
        bucket  = "${TF_STATE_BUCKET}"
        prefix  = "terraform/state"
    }
}
EOF
fi

TERRAFORM_VARIABLE_FILE_PATH=terraform/terraform.tfvars
echo "Generate the terraform variables in ${TERRAFORM_VARIABLE_FILE_PATH}"
if [ -f "${TERRAFORM_VARIABLE_FILE_PATH}" ]; then
    echo "The ${TERRAFORM_VARIABLE_FILE_PATH} file already exists."
else
    tee "${TERRAFORM_VARIABLE_FILE_PATH}" <<EOF
google_project_id="${GOOGLE_CLOUD_PROJECT}"
google_default_region="${GOOGLE_CLOUD_REGION}"
google_default_zone="${GOOGLE_CLOUD_ZONE}"
EOF
fi

