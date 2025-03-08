output "vpc_name" {
  value = google_compute_network.vpc.name
  description = "VPC name"
}

output "vpc_id" {
  value = google_compute_network.vpc.id
  description = "VPC id"
}

output "subnet_id" {
  value = google_compute_subnetwork.subnet.id
  description = "Subnet id"
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
  description = "Subnet name"
}

