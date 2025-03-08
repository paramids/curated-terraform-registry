# Providers used

# terraform {
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "3.52.0"
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = ">= 2.0.1"
#     }
#   }
# }
# provider "google" {
#   project = "${var.google_project_id}"   
#   region = var.location
# }
provider "google" {
  project = "${var.google_project_id}"   
  region = var.region
}

data "terraform_remote_state" "gke" {
    depends_on = [
      module.k8scluster
    ]
    backend = "gcs"
    config = {
      bucket = "tf-state-bucket-sandbox-7205a"
      prefix  = "terraform/state"
     }

}

data "google_client_config" "default" {}
data "google_container_cluster" "my_cluster" {
  depends_on = [
    module.k8scluster
  ]
  name     = data.terraform_remote_state.gke.outputs.kubernetes_cluster_name
  location = var.region
  
}

provider "kubernetes" {
  host = "https://${data.terraform_remote_state.gke.outputs.kubenetes_cluster_endpoint}"

  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}