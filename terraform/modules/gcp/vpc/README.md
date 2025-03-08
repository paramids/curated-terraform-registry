# VPC Module

This module creates an opinited VPC and subnets required by a GKE cluster


## Inputs

| Name                     | Description                    | Type                           | Default          | Required  |
|--------------------------|--------------------------------|:------------------------------:|:----------------:|:---------:|
| name                     | VPC name                       | string                         | -                | yes       |
| region                   | VPC region                     | string                         | "us-central1"    | yes       |
| cidr                     | VPC cidr                       | string                         | -                | yes       |


## Outputs


| Name                                  | Description                                                       |
|---------------------------------------|-------------------------------------------------------------------|
| vpc_name                              | VPC name                                                          |
| vpc_id                                | VPC id                                                            |
| subnet_id                             | Subnet id                                                         |
| subnet_name                           | Subnet name                                                       |