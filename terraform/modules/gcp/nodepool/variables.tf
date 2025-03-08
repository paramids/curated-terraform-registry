variable "project_id" {
    type = string
    description = "Project Id"
}
variable "name" {
    type = string
    description = "Node Pool customer name"
}
variable "cluster_id" {
    type = string
    description = "K8s Cluster Id"
}

variable "machine_type" {
    type = string
    description = "Machine type"
}

variable "oauth_scopes" {
    type = list(string)
    description = "Oauth scope "
    default = [ "https://www.googleapis.com/auth/cloud-platform" ]
}