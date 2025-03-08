# GKE Node Pool Module

This module creates a Node Pool with workload identity enabled


## Inputs

| Name                     | Description                    | Type                           | Default   | Required  |
|--------------------------|--------------------------------|:------------------------------:|:---------:|:---------:|
| project_id               | Project ID                     | string                         | -         | yes       |
| name                     | Node Pool customer name        | string                         | -         | yes       |
| cluster_id               | K8s Cluster Id                 | string                         | -         | yes       |
| machine_type             | Node pool machine type         | string                         | -         | yes       |
| oauth_scopes             | Node pool Oauth scopes         | list(string)                   | -         | yes       |



## Outputs


| Name                                  | Description                                                       |
|---------------------------------------|-------------------------------------------------------------------|
| node_pool_labels                      | Node pool labels                                                  |
| node_pool_tags                        | Node pool tags                                                    |
