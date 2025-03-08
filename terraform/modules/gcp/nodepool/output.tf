output "node_pool_labels" {
  value = google_container_node_pool.np.node_config[0].labels
  description = "Node pool labels"
}

output "node_pool_tags" {
  value = google_container_node_pool.np.node_config[0].tags
  description = "Node pool tags"
}