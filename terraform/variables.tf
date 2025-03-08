
variable "google_project_id" {
  type = string
}

variable "vpc_name" {
  type=string
  description = "VPC Name"
}

variable "vpc_cidr" {
  type =string
  description = "VPC CIDR"
}

variable "k8s_cluster_name" {
  type =string
  description = "K8s Cluster Name"
}

variable "region" {
  type =string
  description = "Deployment Region"
}

variable "k8s_namespace" {
  type =string
  description = "Namespace for workload"
}

variable "k8s_cloudsql_sa_name" {
  type =string
  description = "Name for k8s Service Account"
}

variable "nodepool_map" {
  type = map(object({name=string, machine_type=string, oauth_scopes=list(string)}))
  description = "Map of Node Pool Configuration"
  
}