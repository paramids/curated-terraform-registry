output "cluster_id" {
  value = google_container_cluster.primary.id
  description = "GKE cluster id"
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}
