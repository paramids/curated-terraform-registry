project="sandbox-7205a"
google_project_id="sandbox-7205a"
google_default_region="europe-west1"
google_default_zone="europe-west1-b"
region="us-central1"

vpc_name="test"
vpc_cidr="10.10.0.0/24"
k8s_cluster_name="k8scluster"
k8s_namespace="workload"
k8s_cloudsql_sa_name="account"
nodepool_map = {
  "customer1" = {
    machine_type = "e2-medium"
    name = "customer1"
    oauth_scopes = [ "https://www.googleapis.com/auth/cloud-platform" ]
  },
  "customer2" = {
    machine_type = "e2-medium"
    name = "customer2"
    oauth_scopes = [ "https://www.googleapis.com/auth/cloud-platform" ]
  }
}