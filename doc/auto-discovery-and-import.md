# Auto-discovery and Import of Existing OpenShift Clusters

## Overview
Red Hat Advanced Cluster Management (RHACM) provides a powerful Discovery Service that automatically discovers and imports OpenShift clusters configured within your Red Hat OpenShift Cluster Manager (RHOCM) account. This feature streamlines cluster management by eliminating manual configuration steps.

## Benefits
- **Automated Discovery**: Seamlessly detect clusters in your RHOCM account
- **Zero-Touch Import**: Automatically import discovered clusters into RHACM
- **Simplified Management**: Reduce manual configuration and potential errors

## Implementation
To enable auto-discovery and import functionality, include the following resource in your configuration:

```yaml
resources:
  ## Discover & Import Existing Clusters
  - argocd/clusters/discover/discover-openshift.yaml
```

## Manual Alternative
While the Discovery Service provides automated cluster management, you can still manually discover and import clusters if needed. However, this approach requires additional configuration steps and careful attention to detail.

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>