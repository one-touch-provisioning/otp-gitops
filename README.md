<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<div align="center">
  <a href="https://github.com/one-touch-provisioning/otp-gitops">
    <img src="doc/images/otp-logo.png" alt="Logo">
  </a>

  <!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

  <p align="center">
    One Touch Provisioning (OTP) is a powerful pattern that enables seamless end-to-end provisioning of Red Hat OpenShift clusters, their applications, governance, and policies across Public, Private, On-Premises, and Edge Cloud environments - all through code.
    <br />
    <h3>
    <a href="doc/capabilities.md">Explore OTP Capabilities</a>
    | 
    <a href="https://github.com/one-touch-provisioning/otp-gitops/issues">Report Bug</a>
    |
    <a href="https://github.com/one-touch-provisioning/otp-gitops/issues">Request Feature</a>
    </h3>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
## Table of Contents
  
  <ul>
  <li><a href="#about-the-project">About the Project</a></li>
  <li><a href="introduction-to-concepts-and-technologies-leveraged">Introduction to Concepts and Technologies</a></li>
  <li><a href="#getting-started">Getting Started</a></li>
   <ul>
    <li><a href="#prerequisites">Prerequisites</a></li>
    <li><a href="#installation">Installation</a></li>
   </ul>
  <li><a href="#usage">Usage</a></li>
  <li><a href="#roadmap">Roadmap</a></li>
  <li><a href="#contributing">Contributing</a></li>
  <li><a href="#license">License</a></li>
  <li><a href="#contact">Contact</a></li>
  <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ul>
<br />

<!-- ABOUT THE PROJECT -->
## About the Project

<div align="center">
  <img src="doc/images/ztp.png" alt="One Touch Provisioning" width="850" height="500">
</div>

One Touch Provisioning (OTP) is our opinionated implementation of GitOps principles, leveraging cutting-edge tooling to enable seamless platform provisioning with a single command*. This powerful pattern provides:

- Complete cluster and virtual machine provisioning capabilities
- Comprehensive governance and policy management
- Advanced observability for clusters and workloads
- Automated application deployment, including IBM Cloud Paks

Built on the foundation of Red Hat Advanced Cluster Management (RHACM) and OpenShift GitOps (ArgoCD), OTP enables you to define your entire infrastructure as code. By storing OpenShift clusters, applications, governance, and policies in Git repositories, and leveraging RHACM through OpenShift GitOps, you can achieve truly automated end-to-end provisioning.

Key Benefits:
- Fully codified infrastructure
- Repeatable deployments
- Complete auditability
- Reduced operational overhead

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- INTRODUCTION -->
## Introduction to Concepts and Technologies

Before diving into OTP, it's essential to understand the core concepts and technologies that power this pattern. This knowledge will help you make the most of OTP and understand the reasoning behind our design decisions.

  <ul>
    <li><a href="doc/hubandspoke-concepts.md">Red Hat Advanced Cluster Management Hub and Spoke Clusters Concepts</a></li>
    <li><a href="doc/git-repo-context.md">Git Repositories Context</a></li>
    <li><a href="doc/folder-orgs.md">Git Repository Organization Strategies</a></li>
  </ul>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

#### Red Hat OpenShift Cluster

* Minimum OpenShift v4.10+ is required.

Deploy a "vanilla" Red Hat OpenShift cluster using one of these methods:

<ul>
    <li><a href="doc/ipi-options.md">Installer Provisioned Infrastructure</a></li>
    <li><a href="doc/upi-options.md">User Provisioned Infrastructure</a></li>
    <li><a href="doc/managed-ocp-options.md">Managed OpenShift Offerings</a></li>
    <li><a href="doc/oas.md">OpenShift Assisted Installer</a></li>
</ul>

#### Required CLI Tools

##### OpenShift CLI

- Install the OpenShift `oc` CLI (version 4.10+). You can download the binary from:
  - The Help menu in the OpenShift cluster console
  - The [OpenShift Mirror](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/) website

##### Helm CLI

- Install the Helm CLI using Homebrew:

   ```sh
   brew install helm
   ```

##### KubeSeal CLI (Optional)

- If you plan to use the SealedSecrets Operator, install the kubeseal CLI:

   ```sh
   brew install kubeseal
   ```

#### Repository Structure

OTP uses a Polyrepo structure consisting of six specialized Git repositories within the GitOps workflow. Learn more about our repository organization choice <a href="doc/git-repo-context.md">here</a>.

1. [RHACM Hub GitOps Repository](https://github.com/one-touch-provisioning/otp-gitops)
   - Contains ArgoCD Applications for infrastructure, services, policies, clusters, and application layers
   - Manages resources for both RHACM Hub and Spoke Clusters

2. [Infrastructure GitOps Repository](https://github.com/one-touch-provisioning/otp-gitops-infra)
   - Common repository for cluster-wide and infrastructure resources
   - Manages namespaces, clusterroles, clusterrolebindings, machinesets, etc.
   - Ensures consistent resource deployment across environments

3. [Services GitOps Repository](https://github.com/one-touch-provisioning/otp-gitops-services)
   - Common repository for shared services
   - Manages operator subscriptions, custom resources, and third-party Helm charts
   - Typically managed by administrators and DevOps teams

4. [Policies GitOps Repository](https://github.com/one-touch-provisioning/otp-gitops-policies)
   - Common repository for governance and security policies
   - Manages policies for both Hub and Spoke clusters
   - Typically managed by GRC and Security teams

5. [Clusters GitOps Repository](https://github.com/one-touch-provisioning/otp-gitops-clusters)
   - Common repository for OpenShift cluster definitions
   - Manages cluster deployment configurations
   - Typically managed by Platform Administrators and Operations teams

6. [Apps GitOps Repository](https://github.com/one-touch-provisioning/otp-gitops-apps)
   - Common repository for application deployments
   - Manages application resources for both Hub and Spoke clusters
   - Ensures consistent application deployment across environments

#### Setting Up Git Repositories

1. Create a new GitHub Organization following the [GitHub documentation](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch).

2. Create and clone the repositories in your new GitHub Organization:

   ```sh
   GIT_ORG=<new-git-organization> OUTPUT_DIR=<gitops-repos> ./scripts/create-repos.sh
   ```

3. (`Optional`) For private Git repositories, follow our [private repository setup guide](doc/private-repos.md).

4. Update Git URL and branch references in your `otp-gitops` repository:

    ```sh
    GIT_ORG=<GIT_ORG> GIT_BRANCH=master ./scripts/set-git-source.sh
    ```

   To revert changes:
   ```sh
   ./scripts/unset-git-source.sh
   ```

#### IBM Entitlement Key

If you plan to deploy IBM Cloud Pak for Watson AIOps Infrastructure Automation, follow our [IBM Entitlement Key setup guide](docs/ibm-entitlement-key.md).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Installation -->
### Installation

#### Install and Configure OpenShift GitOps

[Red Hat OpenShift GitOps](https://docs.openshift.com/container-platform/4.13/cicd/gitops/understanding-openshift-gitops.html) uses [Argo CD](https://argoproj.github.io/argo-cd/) for declarative cluster resource management.

1. Install the OpenShift GitOps Operator and create necessary RBAC:

    ```sh
    oc apply -k setup/argocd-operator
    while ! oc wait crd applications.argoproj.io --timeout=-1s --for=condition=Established  2>/dev/null; do sleep 30; done
    while ! oc wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n openshift-gitops > /dev/null; do sleep 30; done
    ```

2. Create a custom ArgoCD instance with configurable health checks:

    ```sh
    oc apply -k setup/argocd-instance
    while ! oc wait pod --timeout=-1s --for=condition=ContainersReady -l app.kubernetes.io/name=openshift-gitops-otp-server -n openshift-gitops > /dev/null; do sleep 30; done
    ```

3. (`Optional`) For IBM Cloud ROKS as RHACM Hub Cluster, configure TLS:

    ```sh
    ./scripts/patch-argocd-tls.sh
    ```

#### Configure Storage and Infrastructure Nodes

For AWS, Azure, GCP, vSphere, and Baremetal deployments, run:

```sh
./scripts/infra-mod.sh
```

This script:
- Deploys additional nodes for OpenShift Data Foundation (ODF)
- Configures infrastructure nodes for RHACM, Quay, Ingress Controllers, etc.
- Optimizes OpenShift licensing by running components on infrastructure nodes

#### IBM Cloud - ROKS Specific Configuration

For IBM Cloud managed OpenShift clusters:
1. Deploy OpenShift Data Foundation as an [add-on](https://cloud.ibm.com/docs/openshift?topic=openshift-ocs-storage-prep#odf-deploy-options)
2. Label worker nodes as infrastructure nodes:

```sh
node-role.kubernetes.io/infra: ''
```

#### Deploy Hashicorp Vault (Optional)

OTP works best with a secret store like Hashicorp Vault. If you have an existing Vault instance (e.g., IBM Secrets Manager), skip to the External Secrets Operator setup.

1. Enable local Vault deployment by uncommenting in `0-bootstrap\hub\2-services\kustomization.yaml`:

   ```yaml
   # Local Hashicorp Vault Instance
   - argocd/instances/hashicorp-vault.yaml
   ```

#### Configure External Secrets Operator

1. Create the API key secret:

   ```sh
   oc create secret generic ibm-secret --from-literal=apiKey='<APIKEY>' -n kube-system
   ```

2. Update ArgoCD application values in `0-bootstrap\hub\2-services\argocd\instances\external-secrets.yaml`

### Bootstrap the RHACM Hub Cluster

The bootstrap process follows the [app of apps pattern](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/#app-of-apps-pattern).

1. Access the ArgoCD UI:

    ```sh
    oc get route -n openshift-gitops openshift-gitops-otp-server -o template --template='https://{{.spec.host}}'
    
    # Password not required if using OpenShift as auth provider
    oc extract secrets/openshift-gitops-otp-cluster --keys=admin.password -n openshift-gitops --to=-
    ```

2. Review and customize deployment resources:

     ```yaml
     0-bootstrap/hub/1-infra/kustomization.yaml
     0-bootstrap/hub/2-services/kustomization.yaml
     0-bootstrap/hub/3-policies/kustomization.yaml
     0-bootstrap/hub/4-clusters/kustomization.yaml
     0-bootstrap/hub/5-apps/kustomization.yaml
     ```

   Note: Changes must be committed to Git before initial bootstrap.

3. Deploy the OpenShift GitOps Bootstrap Application:

    ```sh
    oc apply -f 0-bootstrap/hub/bootstrap.yaml
    ```

4. Manage deployment order using ArgoCD Sync waves:

   Update `0-bootstrap/hub/kustomization.yaml` after Infrastructure, Services, and Policies layers are deployed:

   ```yaml
   resources:
   - 1-infra/1-infra.yaml
   - 2-services/2-services.yaml
   - 3-policies/3-policies.yaml
   ## Uncomment after above layers complete
   # - 4-clusters/4-clusters.yaml
   # - 5-apps/5-apps.yaml
   ```

Installation is complete when all ArgoCD Applications sync successfully.

Access the RHACM Hub console through the OpenShift console.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE -->
## Usage

### Managing OpenShift Clusters with GitOps

OTP treats Managed (Spoke) Clusters as OpenShift GitOps Applications, enabling:
- Cluster creation and destruction
- Cluster hibernation
- Managed cluster import into RHACM

#### Cluster Management Methods

1. **ClusterPools and ClusterClaims**
   - Simplified lifecycle management for AWS, GCP, and Azure clusters
   - Pre-configured cluster templates for consistent deployments
   - Automated cluster provisioning through claims

2. **ClusterDeployment**
   - Supports AWS, Azure, GCP, VMWare, On-Premise, Edge, and IBM Cloud
   - Configure in `0-bootstrap/hub/4-clusters/kustomization.yaml`:

    ```yaml
    resources:
    ## ClusterPools
    - argocd/clusterpools/cicd/aws/aws-cicd-pool/aws-cicd-pool.yaml
 
    ## ClusterClaims
    - argocd/clusterclaims/dev/aws/project-simple.yaml

    ## ClusterDeployments
    - argocd/clusters/prod/aws/aws-prod/aws-prod.yaml
    - argocd/clusters/prod/azure/azure-prod/azure-prod.yaml 
    ```

   - Cloud provider API keys managed through external keystore (Vault)
   - External Secrets Operator for automated key management
   - Deployment configurations in `Clusters` repository under `clusters/deploy/external-secrets/<cloud provider>`

OTP provides complete end-to-end deployment of:
- Clusters
- Policies
- Governance
- Applications

_For detailed usage examples, see our [Documentation](https://github.com/one-touch-provisioning/otp-gitops/doc/usage.md)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [ ] OTP CLI Tool
- [ ] Ansible Automation Integration
  - [ ] Libvirt Support
  - [ ] VMWare Support
- [ ] HyperShift Integration
  - [ ] HyperShift with OpenShift Virtualization for Worker Nodes
- [ ] IBM Cloud Satellite Integration
  - [ ] IBM Managed OpenShift Platform Deployment

See our [open issues](https://github.com/one-touch-provisioning/otp-gitops/issues) for the complete feature roadmap and known issues.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

We welcome contributions to make OTP even better! Your input helps build a stronger open-source community.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Don't forget to star the project! ⭐

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the Apache 2.0 License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Our Team:
<ul>
  <li>Ben Swinney | <a href="https://twitter.com/bdgsts">@bdgsts</a> | <a href="https://www.linkedin.com/in/ben-swinney/">LinkedIn</a> | <a href="https://github.com/benswinney/">GitHub</a></li>
  <li>Cong Nguyen | <a href="https://www.linkedin.com/in/cong-ng/">LinkedIn</a> | <a href="https://github.com/rampadc/">GitHub</a></li>
  <li>Nick Merrett | <a href="https://www.linkedin.com/in/nick-merrett/">LinkedIn</a> | <a href="https://github.com/nickmerrett/">GitHub</a></li>
</ul>

Project Link: [https://github.com/one-touch-provisioning/otp-gitops](https://github.com/one-touch-provisioning/otp-gitops)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

OTP stands on the shoulders of giants. We're grateful to these teams and individuals whose work made this pattern possible:

* [Cloud Native Toolkit - GitOps Production Deployment Guide](https://github.com/cloud-native-toolkit/multi-tenancy-gitops)
* [IBM Garage TSA](https://github.com/ibm-garage-tsa/cp4mcm-installer)
* [Red Hat Communities of Practice](https://github.com/redhat-cop)

The reference architecture for this GitOps workflow can be found [here](https://cloudnativetoolkit.dev/adopting/use-cases/gitops/gitops-ibm-cloud-paks/).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/one-touch-provisioning/otp-gitops.svg?style=for-the-badge
[contributors-url]: https://github.com/one-touch-provisioning/otp-gitops/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/one-touch-provisioning/otp-gitops.svg?style=for-the-badge
[forks-url]: https://github.com/one-touch-provisioning/otp-gitops/network/members
[stars-shield]: https://img.shields.io/github/stars/one-touch-provisioning/otp-gitops.svg?style=for-the-badge
[stars-url]: https://github.com/one-touch-provisioning/otp-gitops/stargazers
[issues-shield]: https://img.shields.io/github/issues/one-touch-provisioning/otp-gitops.svg?style=for-the-badge
[issues-url]: https://github.com/one-touch-provisioning/otp-gitops/issues
[license-shield]: https://img.shields.io/github/license/one-touch-provisioning/otp-gitops.svg?style=for-the-badge
[license-url]: https://github.com/one-touch-provisioning/otp-gitops/blob/master/LICENSE
[product-screenshot]: doc/images/ztp.png