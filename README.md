#### Created by:  Chathushka Parami  De Silva
#### Date:        30/10/2022
#### Description: Terraform scripts to create :
####                 K8s cluster with multiple configurable Node pools per customer.
####                 K8s Namespace to run service workloads.
####                 Service account that connects to CloudSQL in the previously created namespace


# Solution
I am going to use Google Cloud Platform in the solution. The gcp provider and kubenetes providers are used in this soltion. THe gcp provider is used to provision the k8s cluster and node pools. The K8s provider is used to deploy the kubenetes resources (create the workload namespace & service account for cloud sql). In this setup, workload Identity is used to connect application deployed in the k8s cluster to cloud sql. See reference for connecting CloudSQL with GKE for details. 

The repository is divided into two folders:
1. scripts - Folder that contains bootstarpping scripts that automates boilerplate to prepare terraform and its remoted backend. A Storage bucket is used to keep the terraform state and the script handles the creation of service accounts as well.

2. terraform - This folder contains all the modules and resource definitions per deployed environment. The modules folder contains all reusable resources categorized logically with the modules. The environments folder has resource definitions per environment and consists of the root module. The modules folder is subdivided into cloud specific modules and folders for cloud native kubenetes resource creation.


The following decribes the Inputs and Output variables used by the terraform modules:


## Inputs

| Name                     | Description                    | Type                           | Default   | Required  |
|--------------------------|--------------------------------|:------------------------------:|:---------:|:---------:|
| google_project_id        | Project ID                     | string                         | -         | yes       |
| vpc_name                 | VPC Name                       | string                         | -         | yes       |
| vpc_cidr                 | VPC CIDR                       | string                         | -         | yes       |
| k8s_cluster_name         | K8s Cluster Name               | string                         | -         | yes       |
| region                   | Deployment Region              | string                         | -         | yes       |
| k8s_namespace            | Namespace for workload         | string                         | -         | yes       |
| k8s_cloudsql_sa_name     | Name for k8s Service Account   | string                         | -         | yes       |
| nodepool_map             | Map of Node Pool Configuration | map(object(custom))            | -         | yes       |
## Outputs

| Name                                  | Description                                                       |
|---------------------------------------|-------------------------------------------------------------------|
| project_id                            | GCloud Project ID                                                 |
| vpc_id                                | VPC id used to deploy the K8s cluster                             |
| vpc_name                              | VPC name used to deploy the K8s cluster                           |
| kubernetes_cluster_name               | GKE Cluster Name                                                  |
| kubenetes_cluster_endpoint            | K8s cluster endpoint                                              |
| kubenetes_cloudsql_service_account    | Kubenetes service sccount used to authtenticate to Cloud SQL      |
| node_pool_labels                      | Node pool labels                                                  |
| node_pool_tags                        | SNode pool tags"                                                  |


***Notes: The terraform uses the kubenetes provider to provision kubenetes resources in the cluster.Also the terraform statefile has been configures in a gcs bucket for enhanced collaboration and safe storage of state file.


## INSTRUCTIONS TO RUN TERRAFORM

## Setup environment specific variables
Configure the following files in the ./environment/<env name> directory:

1. backend.hcl
-  This file contains the conifigurations of the S3 bucket to hold the terraform state files.
   The gcs bucket should be created before configuring the backend.conf with the following:
        - bucket = <gcp bucket name>
        - prefix = <terraform/state>

2. terraform.tfvars
-  The environment specific variables need to be set in this file with the following values:
        - google_project_id = <project id eg: "${gcloud config get project}">                                                     
        - vpc_name  = <vpc name eg: "test">    
        - vpc_cidr  = <CIDR of the VPC eg: "10.10.0.0/24">                         
        - k8s_cluster_name = <k8s clustername eg: "k8scluster">            
        - region = <project region eg: "us-central1">              
        - k8s_namespace = <namespace for running workload eg: "workload" >  
        - k8s_cloudsql_sa_name = <gcp service account name eg: "account">                     
        - nodepool_map = <map of node pool configs for each customer eg: "{"customer1"={machine_type="ec2-medium",name="customer1",oauth_scopes=["https://www.googleapis.com/auth/cloud-platform"]}}">

## Run Terraform Plan
Once the environment specific variables have been configured, use the following command to initialize and plan:
    1. $ terraform init -backend-config="environments/<env name>/backend.hcl" -reconfigure
        eg: terraform init -backend-config="environments/sandbox/backend.hcl" -reconfigure

    2. $ terraform plan -var-file="environments/<env name>/terraform.tfvars" 
        eg: terraform plan -var-file="environments/sandbox/terraform.tfvars"


## After Verifying, Apply the changes
Run the following command to Apply the changes:

        $ terraform apply -var-file="environments/<env name>/terraform.tfvars" 
        eg: terraform apply -var-file="environments/test-env/terraform.tfvars"


## Understanding the Outputs
Project id, the VPC Id, VPC Name, K8s cluster name, k8s cluster enpoint. k8s-cloudsql service account, node pool labels
and node pool tags. The k8s cluster name and endpoint can be used to retreive kubeconfigs for kubectl command. 

eg:
```
 Outputs:

kubenetes_cloudsql_service_account = {
  "automount_service_account_token" = true
  "default_secret_name" = "account-token-9slnk"
  "id" = "workload/account"
  "image_pull_secret" = toset([])
  "metadata" = tolist([
    {
      "annotations" = tomap({
        "iam.gke.io/gcp-service-account" = "gsa-sql-id@sandbox-7205a.iam.gserviceaccount.com"
      })
      "generate_name" = ""
      "generation" = 0
      "labels" = tomap({})
      "name" = "account"
      "namespace" = "workload"
      "resource_version" = "468995"
      "uid" = "0b8bfbb1-1bc6-40d3-baf7-395b95f4d82f"
    },
  ])
  "secret" = toset([])
  "timeouts" = null /* object */
}
kubenetes_cluster_endpoint = "34.66.148.79"
kubernetes_cluster_name = "k8scluster-gke"
node_pool_labels = {
  "customer1" = tomap({
    "env" = "sandbox-7205a"
    "name" = "customer1"
  })
  "customer2" = tomap({
    "env" = "sandbox-7205a"
    "name" = "customer2"
  })
}
node_pool_tags = {
  "customer1" = tolist([
    "gke-node",
    "sandbox-7205a-gke",
    "customer1",
  ])
  "customer2" = tolist([
    "gke-node",
    "sandbox-7205a-gke",
    "customer2",
  ])
}
project_id = "sandbox-7205a"
vpc_id = "projects/sandbox-7205a/global/networks/test-vpc"
vpc_name = "test-vpc"
```

## Accessing the cluster

Use the terraform output to get the cluster name of the provisioned cluster, i.e kubernetes_cluster_name="k8scluster-gke".
You can use this to generate the kubectl contexts-configs

```
gcloud container clusters get-credentials k8scluster-gke
```

Now you have access to the k8s cluster

### Display Kubenetes Namespace

```
kubectl get ns

Output:

NAME              STATUS   AGE
default           Active   25h
kube-node-lease   Active   25h
kube-public       Active   25h
kube-system       Active   25h
workload          Active   25h
```
### Display Kubenetes Service Account resource that provides access to CloudSQL via workload Identity


```
kubectl -n workload get sa account -o yaml

Output:

apiVersion: v1
automountServiceAccountToken: true
kind: ServiceAccount
metadata:
  annotations:
    iam.gke.io/gcp-service-account: gsa-sql-id@sandbox-7205a.iam.gserviceaccount.com
  creationTimestamp: "2022-10-30T09:25:14Z"
  name: account
  namespace: workload
  resourceVersion: "468995"
  uid: 0b8bfbb1-1bc6-40d3-baf7-395b95f4d82f
secrets:
- name: account-token-9slnk
```
## Convenience Script to generate backend and bootstrap the backend module
The ./scripts directory contains some convenience scripts to generate the backend.tf. Follow the following instructions to bootstrap a new infrastructure deployment
## Prerequisites
1. Install gcloud
2. Install gsutil
3. Google Cloud Project
4. Permission for creating & administering service accounts.
5. Install terraform

## 
1. GCloud Auth

```
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value core/project)
export GOOGLE_APPLICATION_CREDENTIALS=/Users/<user>/.config/gcloud/application_default_credentials.json
```
2. Update the environment variables in the set-env script


3. Run the Generate Backend script
    ```. scripts/generate_backend.sh```

4. Initialize terraform

``` 
cd terraform
terraform init 
```

5. Preview
    ```terraform preview```

6. Apply the Infrastructure 
    ```terraform apply```

## CICD Process
A google cloud build pipeline is defined in cloudbuild.yaml files. This can be configured to trigger terraform apply command when new commits are made to the repo.



## References
1. [Connect to Cloud SQL for MySQL from Google Kubernetes Engine](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine)
2. [Kubenetes provider Service Account resource](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account)