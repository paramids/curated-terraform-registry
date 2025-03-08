resource "google_service_account" "default" {
  account_id   = "sa-${var.name}-nodepool-id"
  display_name = "NodePool Service Account - ${var.name}"
}

resource "google_container_node_pool" "np" {
  name       = "${var.project_id}-${var.name}-nodepool"
  cluster    = var.cluster_id
  node_count = 1
  node_config {
    machine_type = var.machine_type
    service_account = google_service_account.default.email
    oauth_scopes    = var.oauth_scopes

    labels = {
      env = var.project_id
      name = var.name
    }
    tags = ["gke-node", "${var.project_id}-gke", "${var.name}"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  timeouts {
    create = "30m"
    update = "20m"
  }
}