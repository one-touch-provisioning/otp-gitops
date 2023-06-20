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
    One Touch Provisioning (OTP) is a pattern that enables the seamless end-to-end provisioning of Red Hat OpenShift clusters, their applications, governance and policies to Public, Private, On-Premises and both Near and Far Edge Clouds all via Code.
    <br />
    <h3>
    <a href="doc/capabilities.md">OTP Capabilities</a>
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
  <li><a href="introduction-to-concepts-and-technologies-leveraged">Introduction to Concepts and Technologies leveraged</a></li>
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

This method/pattern is our opinionated implementation of the GitOps principles, using the latest and greatest tooling available, to enable the hitting of one big red button (figuratively) to start provisioning a platform that provides Cluster and Virtual Machine Provisioning capabilities, Governance and policy management, observability of Clusters and workloads and finally deployment of applications, such as IBM Cloud Paks, all within a single command*.

The pattern leans very heavily on technologies such as Red Hat Advanced Cluster Management (RHACM) and OpenShift GitOps (ArgoCD), enabling a process upon which OpenShift clusters, their applications, governance and policies are defined in Git repositories and by leveraging RHACM as a function of OpenShift GitOps, enables the seamless end to end provisioning of those environments.

- Codified, Repeatable and Auditable.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- INTRODUCTION -->
## Introduction to Concepts and Technologies leveraged

Before Getting Started with this pattern, it's important to understand some of the concepts and technologies used. This will help reduce the barrier of entry when adopting the pattern and help understand why certain design decisions were made.

  <ul>
    <li><a href="doc/hubandspoke-concepts.md">Red Hat Advanced Cluster Management Hub and Spoke Clusters Concepts</a></li>
    <li><a href="doc/git-repo-context.md">Git Repositories Context</a></li>
    <li><a href="doc/folder-orgs.md">Use-cases for a different Git Repository folder organisation</a></li>
  </ul>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

#### Red Hat OpenShift Cluster

* Minimum OpenShift v4.10+ is required.

Deploy a "vanilla" Red Hat OpenShift cluster using one of the methods below:

<ul>
    <li><a href="doc/ipi-options.md">Installer Provisioned Infrastructure</a></li>
    <li><a href="doc/upi-options.md">User Provisioned Infrastructure</a></li>
    <li><a href="doc/managed-ocp-options.md">Managed OpenShift Offerings</a></li>
    <li><a href="doc/oas.md">OpenShift Assisted Installer</a></li>
</ul>

#### CLI tools

##### OpenShift CLI

- Install the OpenShift `oc` CLI (version 4.10+).  The binary can be downloaded from the Help menu from the OpenShift cluster console, or downloaded from the [OpenShift Mirror](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/) website.

##### Helm CLI

- Install helm CLI from brew.sh

   ```sh
    brew install helm
   ```

##### KubeSeal CLI (Optional)

- If you intend to use the SealedSecrets Operator, then it's recommended to install kubeseal CLI from brew.sh

   ```sh
   brew install kubeseal
   ```

#### Repository considerations

There are two repository patterns to consider when leveraging GitOps: Monorepo or Polyrepo. For OTP, we have leveraged a Polyrepo structure, which consists of six git repositories within the GitOps workflow. You can learn more on why we chose a Polyrepo <a href="doc/git-repo-context.md">here</a>.

- [RHACM Hub GitOps repository](https://github.com/one-touch-provisioning/otp-gitops)
  - This repository contains all the ArgoCD Applications for the `infrastructure`, `services`, `policies`, `clusters` and `application` layers. Each ArgoCD Application will reference a specific resource that will be deployed to the RHACM Hub Cluster, or depending on your chosen configuration, it may include Spoke Cluster resources as well.

- [Infrastructure GitOps repository](https://github.com/one-touch-provisioning/otp-gitops-infra)
  - This repository is what we've termed a "common repository". This repository will be used across both the RHACM Hub cluster and any Spoke clusters you deploy. The repository contains the YAMLs for cluster-wide and/or infrastructure related resources managed by a cluster administrator.  This would include `namespaces`, `clusterroles`, `clusterrolebindings`, `machinesets` to name a few. By leveraging "common repositories", you can reduce depulication of code and ensure a consistant set of resources are applied each time.

- [Services GitOps repository](https://github.com/one-touch-provisioning/otp-gitops-services)
  - This repository is what we've termed a "common repository". This repository will be used across both the RHACM Hub cluster and any Spoke clusters you deploy. The repository contains the YAMLs for resources which will be used by the RHACM Hub and Spoke clusters.  This repository include `subscriptions` for Operators, YAMLs of custom resources provided, or Helm Charts for tools provided by a third party. These resource would usually be managed by the Administrator(s) and/or a DevOps team supporting application developers. By leveraging "common repositories", you can reduce depulication of code and ensure a consistant set of resources are applied each time.

- [Policies GitOps repository](https://github.com/one-touch-provisioning/otp-gitops-policies)
  - This repository is what we've termed a "common repository". The repository contains the YAMLs for resources to deploy `Policies` to both the RHACM Hub and Spoke clusters. These resource would usually be managed by the GRC and/or Security teams. By leveraging "common repositories", you can reduce depulication of code and ensure a consistant set of resources are applied each time.

- [Clusters GitOps repository](https://github.com/one-touch-provisioning/otp-gitops-clusters)
  - This repository is what we've termed a "common repository". The repository contains the YAMLs for resources to deploy `OpenShift Clusters`. These resource would usually be managed by the Platform Administrator(s) and/or a Ops team supporting the Cloud Platforms. By leveraging "common repositories", you can reduce depulication of code and ensure a consistant set of resources are applied each time.

- [Apps GitOps repository](https://github.com/one-touch-provisioning/otp-gitops-apps)
  - This repository is what we've termed a "common repository". The repository contains the YAMLs for resources to deploy the RHACM Hub or Spoke `OpenShift Clusters`. Contains the YAMLs for resources to deploy `applications`. By leveraging "common repositories", you can reduce depulication of code and ensure a consistant set of resources are applied each time.

#### Setup of git repositories

1. Create a new GitHub Organization using instructions from this [GitHub documentation](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch).

2. Create the repositories within your new GitHub Organization and clone them locally.

   ```sh
   GIT_ORG=<new-git-organization> OUTPUT_DIR=<gitops-repos> ./scripts/create-repos.sh
   ```

3. (`Optional`) Many users may wish to use private Git repositories on GitHub to store their manifests, rather than leaving them publically readable. The steps for setting up OpenShift GitOps for Private repositories can be found <a href="doc/private-repos.md">here</a>.

4. Update the default Git URL and branch references in your `otp-gitops` repository by running the provided script `./scripts/set-git-source.sh` script.

    ```sh
    GIT_ORG=<GIT_ORG> GIT_BRANCH=master ./scripts/set-git-source.sh
    ```

   - You can unset the changes you made above by running the `./scripts/unset-git-source.sh`.

#### IBM Entitlement Key for IBM Cloud Paks

If you intend to deploy the `Infrastructure Automation` component of IBM Cloud Pak for Watson AIOps, then please follow the instructions <a href="docs/ibm-entitlement-key.md">here</a>.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Installation -->
### Installation

#### Install and configure OpenShift GitOps

- [Red Hat OpenShift GitOps](https://docs.openshift.com/container-platform/4.13/cicd/gitops/understanding-openshift-gitops.html) uses [Argo CD](https://argoproj.github.io/argo-cd/), an open-source declarative tool, to maintain and reconcile cluster resources.

1. Install the OpenShift GitOps Operator and create a `ClusterRole` and `ClusterRoleBinding`.  

    ```sh
    oc apply -k setup/argocd-operator
    while ! oc wait crd applications.argoproj.io --timeout=-1s --for=condition=Established  2>/dev/null; do sleep 30; done
    while ! oc wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n openshift-gitops > /dev/null; do sleep 30; done
    ```

2. Create a custom ArgoCD instance with custom checks. To customise which health checks, comment out those you don't need in `setup/argocd-instance/kustomization.yaml`.

    ```sh
    oc apply -k setup/argocd-instance
    while ! oc wait pod --timeout=-1s --for=condition=ContainersReady -l app.kubernetes.io/name=openshift-gitops-otp-server -n openshift-gitops > /dev/null; do sleep 30; done
    ```

3. (`Optional`) If using IBM Cloud ROKS as a RHACM Hub Cluster, then you will need to configure TLS.

    ```sh
    ./scripts/patch-argocd-tls.sh
    ```

#### Configure Storage and Infrastructure nodes

On AWS, Azure, GCP, vSphere and Baremetal you can run the following script to configure the machinesets, infra nodes and storage definitions for the `Cloud` you are using for the RHACM Hub Cluster.

This will deploy additional nodes to support OpenShift Data Foundation (ODF) for Persistant Storage, as well as additional nodes to support Infrastructure (aka infra) components, such as RHACM, Quay, Ingress Controllers, OpenShift Internal Registry and ACS.

This is a design choice to reduce OpenShift licensing requirements as running these components on Infrastructure nodes does not consume a subscription cost.

When running on Baremetal, it will utilise Local Storage for deploying ODF. It will autoselect all workerIt will not deploy additional nodes for storage or Infra, this will be improved upon in later versions.

   ```sh
   ./scripts/infra-mod.sh
   ```

#### IBM Cloud - ROKS

If you are running a managed OpenShift cluster on IBM Cloud, you can deploy OpenShift Data Foundation as an [add-on](https://cloud.ibm.com/docs/openshift?topic=openshift-ocs-storage-prep#odf-deploy-options). You will also need to label some of your worker nodes as Infra nodes, otherwise RHACM will fail to deploy.

Attach the following label to the worker nodes you intend to use as Infra nodes.

```sh
node-role.kubernetes.io/infra: ''
```  
#### Install a Local Hashicorp Vault Instance (Optional)

OTP works best when connected to an Secret Store like Hashicorp Vault, if you already have a pre-existing Vault-like instance available, for example IBM Secrets Manager, you can skip this step and move onto installing the External Secrets Operator, however if you'd like to install a local Hashicorp Vault Instances into the Hub Cluster, then follow the below steps.

   ```sh
   oc apply -k setup/hashicorp-vault-chart
   ```

#### Install External Secrets Operator

1. Install the External Secrets Operator to enable OTP to connect to either a pre-existing Vault-like instance or to the Local Hashicorp Vault instance deployed in the previous step.

   ```sh
   oc apply -k setup/external-secrets-operator
   ```

2. Apply the API Key as a secret that will allow OTP to connect to your Vault-like instance via the External Secret Operator.

   ```sh
   oc create secret generic ibm-secret --from-literal=apiKey='<APIKEY>' -n kube-system
   ```

3. Configure the `ClusterSecretStore` with the API Key secret and URL of your Vault-like instance.

   ```yaml
   apiVersion: external-secrets.io/v1beta1
   kind: ClusterSecretStore
   metadata:
     name: cluster
     namespace: external-secrets
   spec:
     provider:
       ibm:
         auth:
           secretRef:
             secretApiKeySecretRef:
               name: ibm-secret
               namespace: kube-system
               key: apiKey
         serviceUrl: >-
           https://3f5f4d5b-6179-4d7c-a7a2-72dc28eb4a81.au-syd.secrets-manager.appdomain.cloud
   ```

4. Apply the updated `ClusterSecretStore`.

   ```sh
   oc apply -f setup/external-secrets-instance/cluster-secret-store.yaml
   ```

### Bootstrap the OpenShift RHACM Hub cluster

The bootstrap YAML follows the [app of apps pattern](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/#app-of-apps-pattern). 

1. Retrieve the ArgoCD/GitOps URL and admin password and log into the UI

    ```sh
    oc get route -n openshift-gitops openshift-gitops-otp-server -o template --template='https://{{.spec.host}}'
    
    # Password is not required if using the OpenShift as an authorisation provider
    oc extract secrets/openshift-gitops-otp-cluster --keys=admin.password -n openshift-gitops --to=-
    ```

2. The resources required to be deployed for this pattern have been pre-selected. However, you can review and modify the resources deployed by editing the following.

     ```yaml
     0-bootstrap/hub/1-infra/kustomization.yaml
     0-bootstrap/hub/2-services/kustomization.yaml
     0-bootstrap/hub/3-policies/kustomization.yaml
     0-bootstrap/hub/4-clusters/kustomization.yaml
     0-bootstrap/hub/5-apps/kustomization.yaml
     ```

  Any changes to the kustomization files before the Initial Bootstrap, will need to be committed back to your Git repository, otherwise they will not be picked up by OpenShift GitOps.

3. Deploy the OpenShift GitOps Bootstrap Application.

    ```sh
    oc apply -f 0-bootstrap/hub/bootstrap.yaml
    ```

4. ArgoCD Sync waves are used to managed the order of manifest deployment, this is required as some objects have parent-child relationships and are expected to exist within the RHACM Hub before they can be successfully deployed. We have seen occassions where applying both the Infrastructure, Services and Policies layers at the same time can fail. This typically occurs when there are issues with provisioning of additional nodes to support Storage and Infrastructure components. YMMV.

Once the Infrastructure, Services and Policies layers have been deployed, update the `0-bootstrap/hub/kustomization.yaml` manifest to enable the Clusters and Apps layer and commit to Git. OpenShift GitOps will then automatically deploy any resources listed within those Kustomise files.

   ```yaml
   resources:
   - 1-infra/1-infra.yaml
   - 2-services/2-services.yaml
   - 3-policies/3-policies.yaml
   ## Uncomment once the above layers have completed.
   # - 4-clusters/4-clusters.yaml
   # - 5-apps/5-apps.yaml
   ```

Installation is successful once all ArgoCD Applications are fully synced without errors.

You will be able to access the RHACM Hub console via the OpenShift console.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE -->
## Usage

### Deploying and Destroying Managed (aka Spoke) OpenShift Clusters via OpenShift GitOps

This pattern treats Managed (aka Spoke) Clusters as OpenShift GitOps Applications. This allows us to Create, Destroy, Hibernate and Import Managed Clusters into Red Hat Advanced Cluster Management via OpenShift GitOps.

#### Creating and Destroying Managed OpenShift Clusters

- ClusterPools and ClusterClaims

  - We've now simplied the life-cycling of OpenShift Clusters on AWS, Google Cloud and Azure via the use of [Cluster Pools](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html/clusters/managing-your-clusters#managing-cluster-pools) and [ClusterClaims](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html/clusters/managing-your-clusters#clusterclaims).

  - Cluster Pools allows you pre-set a common cluster configuration and RHACM will take that configuration and apply it to each Cluster it deploys from that Cluster Pool. An example could be that a Production Cluster may consume specific Compute resources, exist in a multi-zone configuration and requires a particular version of OpenShift to be deployed and RHACM will deploy a cluster to meet those requirements.

  - Once a Cluster Pool has been created, you can submit ClusterClaims to deploy a cluster from that pool.

- ClusterDeployment

  - The ClusterDeployment method can be used to deploy AWS, Azure, GCP, VMWare, On-Premise, Edge and IBM Cloud OpenShift Clusters.

  - Review the `Clusters` layer [kustomization.yaml](0-bootstrap/hub/4-clusters/kustomization.yaml) to enable/disable the Clusters that will be deployed via OpenShift GitOps.

    ```yaml
    resources:
    ## ClusterPools
    ## Example: - argocd/clusterpools/<env>/<cloud>/<clusterpoolname>/<clusterpoolname.yaml>
    - argocd/clusterpools/cicd/aws/aws-cicd-pool/aws-cicd-pool.yaml
 
    ## ClusterClaims
    ## Example : - argocd/clusterclaims/<env>/<cloud>/<clusterclaimname.yaml>
    - argocd/clusterclaims/dev/aws/project-simple.yaml

    ## ClusterDeployments
    ## Example : - argocd/<env>/<cloud>/<clustername>/<clustername.yaml>
    - argocd/clusters/prod/aws/aws-prod/aws-prod.yaml
    - argocd/clusters/prod/azure/azure-prod/azure-prod.yaml 
    ```

  - We have have provided examples for deploying new clusters into AWS, Azure, IBM Cloud and VMWare. Cluster Deployments require the use of your Cloud Provider API Keys to allow RHACM to connect to your Cloud Provider and deploy via Terraform an OpenShift cluster. We make use of an external keystore, e.g. Vault and leveraged the use of the External Secrets Operator to pull in the Cloud Providers API keys automatically. This simplifies the creation of new clusters, reduces the values needed and works better with Scale. The deployments for the clusters is stored within the `Clusters` repository, under `clusters/deploy/external-secrets/<cloud provider>`.
  
  - Originally the pattern utilised the SealedSecrets Controller to encrypt your API Keys and provided a handy script for each Cloud Provider within the `Clusters` repository, under `clusters/deploy/sealed-secrets/<cloud provider>` for your use. This was deemed an ok method for 1-5 cluster deployments, but became very cumbersome when dealing with Scale and was at risk of error and misconfiguration. We will no longer be iterating the code for cluster deployment via SealedSecret and we'll eventually remove this altogether.

The pattern provides full end to end deployment of not only Clusters, but also Policies, Governance and Applications.

_For more usage examples, please refer to the [Documentation](https://github.com/one-touch-provisioning/otp-gitops/doc/usage.md)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [ ] OTP cli
- [ ] Ansible Automation integration with Libvirt and VMWare
- [ ] HyperShift Integration
    - [ ] HyperShift with OpenShift Virtualisation for Worker nodes
- [ ] Deployment of IBM Cloud Satellite for IBM Managed OpenShift platform within chosen environment.

See the [open issues](https://github.com/one-touch-provisioning/otp-gitops/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the APACHE 2.0 License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

<ul>
  <li>Ben Swinney | <a href="https://twitter.com/bdgsts">@bdgsts</a> | <a href="https://www.linkedin.com/in/ben-swinney/">Linkedin</a> | <a href="https://github.com/benswinney/">Github</a></li>
  <li>Cong Nguyen | <a href="https://www.linkedin.com/in/cong-ng/">Linkedin</a> | <a href="https://github.com/rampadc/">Github</a></li>
  <li>Nick Merrett | <a href="https://www.linkedin.com/in/nick-merrett/">Linkedin</a> | <a href="https://github.com/nickmerrett/">Github</a></li>
  <li>Marwan Attar | <a href="https://www.linkedin.com/in/marwan-attar/">Linkedin</a></li>
  <li>Langley Millard | <a href="https://www.linkedin.com/in/langley-millard/">Linkedin</a></li>
</ul>

Project Link: [https://github.com/one-touch-provisioning/otp-gitops](https://github.com/one-touch-provisioning/otp-gitops)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

This asset has been built on the shoulders of giants and leverages the great work and efforts undertaken by the teams/individuals below. Without these efforts, then this pattern would have struggled to get off the ground.

The reference architecture for this GitOps workflow can be found [here](https://cloudnativetoolkit.dev/adopting/use-cases/gitops/gitops-ibm-cloud-paks/).

* [Cloud Native Toolkit - GitOps Production Deployment Guide](https://github.com/cloud-native-toolkit/multi-tenancy-gitops)
* [IBM Garage TSA](https://github.com/ibm-garage-tsa/cp4mcm-installer)
* [Red Hat Communities of Practice](https://github.com/redhat-cop)

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