# Hibernating Managed OpenShift Clusters

* You can Hibernate deployed Managed OpenShift Clusters running on AWS, Azure and GCP when not in use to reduce on running costs. This has to be done *AFTER* a cluster has been deployed. This is accomplished by modifying the `spec.powerState` from `Running` to `Hibernating` of the ClusterDeployment manifest (Located under `<otp-gitops>/0-bootstrap/hub/4-clusters/clusters/<env>/<cloud>/<clusterdeploymentname>/<clusterdeploymentname.yaml>`) of the Managed OpenShift Cluster and committing to Git.

  ```yaml
  spec:
    powerState: Hibernating
  ```

* To resume a hibernating Managed OpenShift Cluster, you modify the `spec.powerState` value from `Hibernating` to `Running` and commit to Git.

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>