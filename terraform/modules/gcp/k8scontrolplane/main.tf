# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.name}-gke"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_id
  subnetwork = var.subnet_id

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}