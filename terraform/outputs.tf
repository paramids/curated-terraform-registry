
output "project_id" {
  value       = var.google_project_id
  description = "GCloud Project ID"
}

output "vpc_id" {
    value = module.vpc.vpc_id
    description = "VPC id used to deploy the K8s cluster"
}

output "vpc_name" {
    value = module.vpc.vpc_name
    description = "VPC name used to deploy the K8s cluster"
}



output "kubernetes_cluster_name" {
  value       = module.k8scluster.cluster_name
  description = "GKE Cluster Name"
}

output "kubenetes_cluster_endpoint" {
  value = module.k8scluster.cluster_endpoint
  description = "K8s cluster endpoint"
}

output "kubenetes_cloudsql_service_account" {
    value = kubernetes_service_account.cloudsql
    description = "Kubenetes service sccount used to authtenticate to Cloud SQL"
}

output "node_pool_labels" {
  value = {for k,v in module.nodepool : k => v.node_pool_labels }
  description = "Node pool labels"
}

output "node_pool_tags" {
  value = {for k,v in module.nodepool : k => v.node_pool_tags}
  description = "Node pool tags"
}