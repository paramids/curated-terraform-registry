variable "name" {
    type = string
    description = "VPC name"
}

variable "region" {
    type = string
    description = "VPC region"
    default = "us-central1"
}

variable "cidr" {
    type = string
    description = "VPC CIDR "
}