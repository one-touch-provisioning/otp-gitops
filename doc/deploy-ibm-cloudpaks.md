# Deploying IBM Cloud Paks with OpenShift GitOps

This guide demonstrates how to deploy IBM Cloud Paks using OpenShift GitOps, using IBM Cloud Pak for Integration (CP4i) as a practical example. We'll walk through the process of preparing your managed clusters for CP4i deployment, including setting up OpenShift Container Storage, configuring nodes with appropriate resources, and installing required services and tools.

## Prerequisites

Before you begin, ensure you have:
- Access to your managed cluster
- The Cloud Native Toolkit - GitOps Production Deployment Guide repositories configured
- An IBM Cloud Pak entitlement key

## Deployment Steps

### 1. Access Your Managed Cluster

```bash
# Log into your managed cluster using the OpenShift CLI
oc login --token=<token> --server=<server> 
```

### 2. Configure Infrastructure

```bash
# Clone your configured multi-tenancy-gitops repository
git clone git@github.com:cp4i-cloudpak/multi-tenancy-gitops.git

cd multi-tenancy-gitops
# Configure infrastructure details for your managed cluster
./scripts/infra-mod.sh
```

### 3. Set Up IBM Entitlement Secret

Create an IBM Entitlement Secret in the tools namespace:

```bash
# Create the tools namespace if it doesn't exist
oc new-project tools || true

# Create the entitlement secret
oc create secret docker-registry ibm-entitlement-key -n tools \
--docker-username=cp \
--docker-password="<entitlement_key>" \
--docker-server=cp.icr.io
```

> **Note:** To obtain your entitlement key:
> 1. Visit [IBM Container Library](https://myibm.ibm.com/products-services/containerlibrary)
> 2. Log in with your IBM ID associated with the entitled software
> 3. Select "View library" to verify your entitlements
> 4. Click "Get entitlement key" to retrieve your key

### 4. Configure Cloud Pak Placement

Update the placement rule in your `otp-gitops-apps` repository to specify your target cluster:

```yaml
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: ibm-cp4i-argocd
  namespace: openshift-gitops
  labels:
    app: ibm-cp4i-argocd
spec:
  clusterConditions:
  - status: "True"
    type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions: []
    matchLabels:
      # Update this value with your target cluster name
      name: aws-ireland
```

### 5. Enable CP4i Application

Uncomment the CP4i Application in your `kustomization.yaml` file:

```yaml
resources:
# Deploy Applications to Managed Clusters
## Include the Applications you wish to deploy below
## An example has been provided
 - argocd/cloudpaks/cp4i/cp4i.yaml
```

## What Happens Next?

Once you commit these changes to Git, OpenShift GitOps will automatically:
1. Create a Red Hat Advanced Cluster Management (RHACM) Application
2. Subscribe to your configured `multi-tenancy-gitops` repository
3. Apply the manifests through the Managed Cluster's OpenShift-GitOps controller

## Future Improvements

We're continuously working to enhance this deployment process. Future releases will aim to:
- Automate the manual steps using SealedSecrets
- Integrate with Vault for secure secret management
- Implement Ansible Tower for automated configuration

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>