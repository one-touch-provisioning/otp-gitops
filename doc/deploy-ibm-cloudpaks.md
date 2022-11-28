# Deployment of Cloud Paks through OpenShift GitOps

We will use IBM Cloud Pak for Integration (CP4i) as an example Application that can be deployed onto your Managed Clusters. As mentioned previously, we re-use the GitOps approach, and utilise OpenShift GitOps to configure the cluster ready for CP4i, through deploying OpenShift Container Storage, creating Nodes with the correct CPU and Memory, installing the necessary services and tools, and finally, deploy CP4i with MQ and ACE.

There is a few minor manual steps which need to be completed, and that is preparing the CP4i respository with your Cloud details and adding the IBM Cloud Pak Entitlement Secret into the Managed Cluster. In future, we aim to automate this step via SealedSecrets, Vault and Ansible Tower.

We will use the [Cloud Native Toolkit - GitOps Production Deployment Guide](https://github.com/cloud-native-toolkit/multi-tenancy-gitops) repositories and it is assumed you have already configured these repostories by following the very comprehensive guide put together by that team. That configuration of those repositories are beyond the scope of this asset.

```bash
# Log into Managed Cluster that the CP4i will be deployed too via oc login
oc login --token=<token> --server=<server> 

# Clone the multi-tenancy-gitops repository you configured via the Cloud Native Toolkit - GitOps Production Deployment Guide
git clone git@github.com:cp4i-cloudpak/multi-tenancy-gitops.git

cd multi-tenancy-gitops
# Run the infra-mod.sh script to configure the Infrastruture details of the Managed Cluster
./scripts/infra-mod.sh

# Create an IBM Entitlement Secret within the tools namespace
   
## To get an entitlement key:
## 1. Log in to https://myibm.ibm.com/products-services/containerlibrary with an IBMid and password associated with the entitled software.  
## 2. Select the **View library** option to verify your entitlement(s). 
## 3. Select the **Get entitlement key** to retrieve the key.

oc new-project tools || true
oc create secret docker-registry ibm-entitlement-key -n tools \
--docker-username=cp \
--docker-password="<entitlement_key>" \
--docker-server=cp.icr.io
```

*Note:* Our aim is to reduce these steps in future releases of the asset.

You will need to update the `tenents/cloudpaks/cp4i/cp4i-placement-rule.yaml` file within the `otp-gitops-apps` repository to match the cluster you wish to deploy the Cloud Pak to and commit to Git.

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
      # Replace value with Cluster you wish to provision too.
      name: aws-ireland
```

Uncomment the CP4i Application within `Application` [kustomization.yaml](0-bootstrap/3-apps/kustomization.yaml) file and commit to Git.

```yaml
resources:
# Deploy Applications to Managed Clusters
## Include the Applications you wish to deploy below
## An example has been provided
 - argocd/cloudpaks/cp4i/cp4i.yaml
```

OpenShift GitOps will create a RHACM Application that subscribes to the `multi-tenancy-gitops` repository you configured and apply the manifests to the Managed Cluster's OpenShift-GitOps controller.

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>