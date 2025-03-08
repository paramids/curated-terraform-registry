
#********************************************************************************************************
#****************************************************Q1********************************************
#********************************************************************************************************



# VPC
module "vpc" {
  source = "./modules/gcp/vpc"
  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr}"
}

#Create k8s cluster control plane
module "k8scluster" {
  source = "./modules/gcp/k8scontrolplane"
  name = "${var.k8s_cluster_name}"
  project_id = var.google_project_id
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  region = "${var.region}"
}

#Create Node pool
module "nodepool" {
  for_each = var.nodepool_map
  source = "./modules/gcp/nodepool"
  cluster_id= module.k8scluster.cluster_id
  project_id = var.google_project_id
  name = each.value.name
  machine_type = each.value.machine_type
  oauth_scopes = each.value.oauth_scopes
}

#Create namespace
resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = "${var.k8s_namespace}"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "${var.k8s_namespace}"
  }
}


#Create Kubenetes SA 

resource "kubernetes_service_account" "cloudsql" {
  metadata {
    name = "${var.k8s_cloudsql_sa_name}"
    namespace = kubernetes_namespace.example.metadata.0.name
    annotations = {
      "iam.gke.io/gcp-service-account" = "${google_service_account.service_account.email}"
    }
  }
}

# Create GCP Service Account Cloud SQL
resource "google_service_account" "service_account" {
  account_id   = "gsa-sql-id"
  display_name = "Cloud SQL Service Account"

}

resource "google_project_iam_member" "cloudsql-role" {
  project = var.google_project_id
  role    = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "workload_identity-role" {
  project = var.google_project_id
  role = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${var.google_project_id}.svc.id.goog[workload/account]"
}



#********************************************************************************************************
#****************************************************Q1********************************************
#********************************************************************************************************
