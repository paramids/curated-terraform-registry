variable "project_id" {
    type = string
    description = "Project ID"
}
variable "name" {
    type = string
    description = "K8s Cluster Name"
}

variable "region" {
    type = string
    description = "Deployment Region"
}

variable "gke_num_nodes" {
  default     = 1
  description = "Number of gke nodes per node pool"
}

variable "vpc_id" {
  type = string
  description = "Name of VPC used to deploy cluster"
}

variable "subnet_id" {
  type = string
  description = "Cluster subnet Name"
}