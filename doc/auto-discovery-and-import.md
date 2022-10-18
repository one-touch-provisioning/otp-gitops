# Auto-discovery and import of existing OpenShift Clusters

* Red Hat Advanced Cluster Management makes the use of the Discovery Service, that will auto-discover and import OpenShift Clusters configured within your Red Hat OpenShift Cluster Manager (RHOCM) account. You can still perform this action outside of the Discovery Service, but this does mean that manual steps are required.

  ```yaml
  resources:
  ## Discover & Import Existing Clusters
   - argocd/clusters/discover/discover-openshift.yaml
  ```

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>