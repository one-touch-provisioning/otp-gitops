# Hibernating Managed OpenShift Clusters

## Overview
Save costs on your Managed OpenShift clusters by hibernating them when not in use. This feature is available for clusters running on AWS, Azure, and GCP platforms.

## Prerequisites
- A successfully deployed Managed OpenShift cluster
- Access to the cluster's GitOps configuration

## How to Hibernate a Cluster
To hibernate a running cluster, follow these steps:

1. Locate your cluster's ClusterDeployment manifest at:
   ```
   <otp-gitops>/0-bootstrap/hub/4-clusters/clusters/<env>/<cloud>/<clusterdeploymentname>/<clusterdeploymentname.yaml>
   ```

2. Modify the `spec.powerState` from `Running` to `Hibernating`:
   ```yaml
   spec:
     powerState: Hibernating
   ```

3. Commit and push the changes to your Git repository

## Resuming a Hibernated Cluster
To bring your cluster back online:

1. Locate the same ClusterDeployment manifest
2. Change the `spec.powerState` from `Hibernating` to `Running`
3. Commit and push the changes to your Git repository

## Benefits
- Significantly reduce operational costs when clusters are not in use
- Maintain cluster configuration and data while hibernated
- Quick and easy process to resume clusters when needed

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>