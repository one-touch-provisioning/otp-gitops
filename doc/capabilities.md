# Pattern Capabilities

   - The pattern will deploy an opionated [Red Hat Advanced Cluster Management](https://www.redhat.com/en/technologies/management/advanced-cluster-management) configuration which we will term as our **Hub** Cluster running OpenShift GitOps (ArgoCD), OpenShift Pipelines (Tekton), OpenShift Data Foundation (Rook.io), Ansible Automation Platform (Additional Subscription required), Red Hat Advanced Cluster Management (Open Cluster Management), Red Hat Advanced Cluster Security (Stackrox), Quay Registry, Quay Container Security, OpenShift Virtualisation (KubeVirt), IBM Infrastructure Automation from the IBM Cloud Pak for AIOps 3.2, Instana, Turbonomics, External Secrets and RHACM Observability.

   - Deployment and management of Managed OpenShift Clusters via OpenShift GitOps (everything is Infrastructure as Code) onto Amazon Web Services, Microsoft Azure, IBM Cloud, Google Cloud Platform, VMWare vSphere and Bare-metal environments, including Single Node OpenShift onto On Premise hosts. Allowing Managed OpenShift Clusters to be treated as "Cattle" not "Pets".

   - Deployed Managed OpenShift Clusters on AWS, Azure and GCP can be Hibernated when not in-use to reduce the amount of resources consumed on your provider, potentially lowering costs.

   - Configured to Auto-Discover OpenShift Clusters from provided Red Hat OpenShift Cluster Manager credentials, and provide the opportunity to import the OpenShift clusters as Managed Clusters and automatically configure them into the OpenShift GitOps Cluster.

   - Centralised OpenShift GitOps for deployment of Applications across any Managed OpenShift Cluster. View all deployed Applications across the entire fleet of OpenShift Clusters, regardless of Clusters location (i.e. AWS, GCP, on-premise etc).

   - Automatically apply policies and governance to ALL Clusters within Red Hat Advanced Cluster Management, regardless of Clusters location.

   - Hub Cluster can self-host Instana Virtual Machine using OpenShift Virtualisation and managed via OpenShift GitOps, or automatically deployed to an IaaS environment using IBM Infrastructure Automation.

   - Can be configured to automatically connect to IaaS environments, enable deployment of Virtual Machines via IBM Infrastructure Automation and OpenShift Pipelines.

   - Can be configured to automatically deploy applications to Managed Clusters via OpenShift GitOps. An example provided will deploy IBM Cloud Pak for Integration (utilising full GitOps Principles) to Managed Clusters.

   - Zero Touch Provisioning of Managed OpenShift Clusters to Bare-metal nodes to support Near and Far Edge deployments
  
<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>