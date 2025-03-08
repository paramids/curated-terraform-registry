# GKE cluster Module

This module creates an opiniated GKE cluster with workload identity enableds



## Inputs

| Name                     | Description                    | Type                           | Default   | Required  |
|--------------------------|--------------------------------|:------------------------------:|:---------:|:---------:|
| project_id               | Project ID                     | string                         | -         | yes       |
| name                     | K8s Cluster Name               | string                         | -         | yes       |
| region                   | Deployment Region              | string                         | -         | yes       |
| gke_num_nodes            | bastion EC2 instance type      | string                         | `1`       | yes       |
| vpc_id                   | VPC id used to deploy cluster  | string                         | -         | yes       |
| subnet_id                | VPC CIDR                       | string                         | -         | yes       |

## Outputs

| Name                                  | Description                                                       |
|---------------------------------------|-------------------------------------------------------------------|
| cluster_id                            | GKE cluster id                                                    |
| cluster_name                          | GKE cluster name                                                  |
| cluster_endpoint                      | GKE cluster endpoint                                              |
