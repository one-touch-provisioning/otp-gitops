<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/one-touch-provisioning/otp-gitops">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">One Touch Provisioning</h3>

  <p align="center">
    One Touch Provisioning enables the seamless end-to-end provisioning of Red Hat OpenShift clusters, their applications, governance and policies to Public, Private and On-Premise Clouds all via Code.
    <br />
    <a href="https://github.com/one-touch-provisioning/otp-gitops"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/one-touch-provisioning/otp-gitops">View Demo</a>
    ·
    <a href="https://github.com/one-touch-provisioning/otp-gitops/issues">Report Bug</a>
    ·
    <a href="https://github.com/one-touch-provisioning/otp-gitops/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#pattern-capabilities">Pattern Capabilities</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#red-hat-advanced-cluster-management-hub-and-spoke-clusters-concepts">Red Hat Advanced Cluster Management Hub and Spoke Clusters Concepts</a></li>
        <li><a href="#context-behind-the-git-repositories">Context behind the Git Repositories</a></li>
        <li><a href="#use-cases-for-different-folder-organisation-of-git-repositories">Use-cases for different folder organisation of Git Repositories</a></li>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>
<br />

<!-- ABOUT THE PROJECT -->
## About The Project 🚀

[![OTP][product-screenshot]](https://github.com/one-touch-provisioning)

This method/pattern is our opinionated implementation of the GitOps principles, using the latest and greatest tooling available, to enable the hitting of one big red button (figuratively) to start provisioning a platform that provides Cluster and Virtual Machine Provisioning capabilities, Governance and policy management, observability of Clusters and workloads and finally deployment of applications, such as IBM Cloud Paks, all within a single command*.

The pattern leans very heavily on technologies such as Red Hat Advanced Cluster Management (RHACM) and OpenShift GitOps (ArgoCD), enabling a process upon which OpenShift clusters, their applications, governance and policies are defined in Git repositories and by leveraging RHACM as a function of OpenShift GitOps, enables the seamless end to end provisioning of those environments.

- Codified, Repeatable and Auditable.

* Disclaimer, may actually be more than just one command to type. 😉

<details>
  <summary>Pattern Capabilities</summary>

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
</details>

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

Before Getting Started with this pattern, it's important to understand some of the concepts and technologies used.

<details>
  <summary>Red Hat Advanced Cluster Management Hub and Spoke Clusters Concepts</summary>
  
  We leverage two Open Source technologies to underpin the functionality within this pattern. One is ArgoCD (aka OpenShift Gitops) and the other is Open Cluster Management (aka Red Hat Advanced Cluster Management or RHACM).

  To fully appreciate the terminology used within RHACM and more so within the pattern, we will spend a few moments helping provide some context.

  RHACM is built around a Hub and Spoke architecture. With the Hub Cluster, running RHACM, providing cluster and application lifecycle along with other aspects such as Governance and Observability of any Spoke Clusters under it's management.

  The diagram below shows a typical Hub and Spoke deployment over various clouds.

  ![Hub and Spoke](doc/images/hubandspoke.png)
</details>

<details>
  <summary>Context behind the Git Repositories</summary>

  We leverage several repositories to make up the pattern. These may seem as overwhelming to begin with, but there is some method and thoughts behind them. We approached this pattern with scale in mind and running a single mono repository with all the manifests quickly showed that it does not lend itself to scale that well.

  We really want a method that allows a decentralised approach to scale. One where teams are working together across the entire pattern, with some guard-rails, to enable rapid deployment of OpenShift Clusters, Applications and Policies at scale.

  Taking the Kubernetes Ownership Model, we looked at which personas would typically contribute and have ownership over a repository and separated a single mono repository into several to reflect that. An example would be a Platform team that primarily contributes and has ownership over a repository that defines the [infrastructure-related](https://github.com/one-touch-provisioning/otp-gitops-infra) components of a Kubernetes Cluster, e.g. namespaces, machinesets, ingress-controllers, storage etc, they may also be best placed to contribute and own a repository that defines how OpenShift [Clusters](https://github.com/one-touch-provisioning/otp-gitops-clusters) are created on different Cloud Providers. Similar examples can be given for a set of Services which support Application developers, where we would separate these into their own repositories, again owned and primarily contributed by a Services team. A Risk/Security team owning and primarily contributing to a [Policies](https://github.com/one-touch-provisioning/otp-gitops-policies) repository is another example.

  We then look to enable all these repositories as centralised repositories, either at an organisational, business or product level, where each OpenShift Cluster, including the Hub Cluster, is deployed with OpenShift GitOps (aka ArgoCD) and bootstrapped via a single repository, within which hold ArgoCD Applications that point back to these centralised repositories.

  The advantages of this approach is a reduction of duplicated code and ensures that deployed OpenShift Clusters all meet or share the same configuration, where applicable. For example node sizes, autoscaling, networking etc or RBAC policies that are important for overall governance and security. As a result, the desired configurations are fully replicated across the Clusters, regardless of where they land, Public, Private, On-Prem etc.

  Manually identifying drift and maintaining conformance across different clusters within different Clouds as they scale is, of course, not a viable alternative, so this approach lends itself very well.

  By utilising a shared and decentralised approach, this has the added advantage of lowering the barrier to entry (e.g., a Developer needs to understand how we are deploying a cluster, they can read the Git Repository without needing to delay the Platform team), lowering the cost for change and Opening up Opportunities to Innovate.

  For our pattern, we've termed the above 1 + 5 + n Git Repositories.

  * 1 Repository being the Red Hat Advanced Cluster Management Hub Cluster

  * 5 Repositories (Infrastructure, Services, Applications, Clusters, Policies) being common / shared

  * n Repository being the repository that you will use to bootstrap your deployed managed OpenShift Cluster

  ![1+5+n Repositories](doc/images/15n-repos.gif)
 
  By using a common set of repositories we can quickly scale out Cluster Deployments and reducing the risk of misconfiguration and drift.
</details>

<details>
  <summary>Use-cases for different folder organisation of Git Repositories</summary>
  
  As we mature this method/pattern, we have seen different use-cases where the need for a different Git Repository folder organisation has been required.

  Our view by leveraging the 1 + 5 + n Git Repositories it allows more flexability to what is deployed into cluster and works better at scale. The Line of Business, Product team, end-users etc can have full control via their own ArgoCD instance which is configured against a Git repository they control. This works for privacy and security as they control who can and cannot see the objects within their repository. We'll term this a `self-managed Cluster`. This may suit a team which has experience in OpenShift, clearly understand their requirements, and are comfortable managing the environment themselves.

  However there are occassions where there maybe a requirement for a Cluster to be provisioned and the end-users wish for a more `managed cluster`. They understand their applications, and prefer to just focus on those aspects. They are happy to commit to a Git Repository that they do not own and prefer that management of the Cluster is owned by another team. In this scenario, it would make sense to manage the cluster and its applications via the Hub Repository alone. Think of this as a `shared-multi-tenancy` operational model. Everyone with access to the Git repository can see all objects within. To demo this model, we've left example folder structures for the `managed` use-case. This can be found in `0-bootstrap/spokeclusters/`.

  It should be noted that these are just a few methods to manage your environments, and we encourage you to choose a method that works for you.
</details>

### Prerequisites ⬅️

*Red Hat OpenShift Cluster*

Minimum OpenShift v4.10+ is required.

Deploy a "vanilla" Red Hat OpenShift cluster using either IPI (Installer Provisioned Infrastructure), UPI (User Provisioned Infrastructure), OAS (OpenShift Assisted Service) methods or a Managed OpenShift offering like AWS ROSA, Azure ARO or IBM Cloud - ROKS.

<details>
  <summary>IPI Methods</summary>
  
  * [AWS](https://docs.openshift.com/container-platform/4.8/installing/installing_aws/installing-aws-default.html)
  * [Azure](https://docs.openshift.com/container-platform/4.8/installing/installing_azure/installing-azure-default.html)
  * [VMWare](https://docs.openshift.com/container-platform/4.8/installing/installing_vsphere/installing-vsphere-installer-provisioned.html)
</details>
<details>
  <summary>UPI Methods</summary>

  - [Azure](https://github.com/ibm-cloud-architecture/terraform-openshift4-azure)
  - [AWS](https://github.com/ibm-cloud-architecture/terraform-openshift4-aws)
  - [VMWare](https://github.com/ibm-cloud-architecture/terraform-openshift4-vmware)
  - [IBM Cloud VMWare Cloud Director](https://github.com/ibm-cloud-architecture/terraform-openshift4-vcd)
  - [GCP](https://github.com/ibm-cloud-architecture/terraform-openshift4-gcp)
  - [IBM Power Systems - PowerVC](https://github.com/ocp-power-automation/ocp4-upi-powervm)
  - [IBM Power Systems - HMC](https://github.com/ocp-power-automation/ocp4-upi-powervm-hmc)
  - [IBM Cloud PowerVS](https://github.com/ocp-power-automation/ocp4-upi-powervs)
</details>
<details>
  <summary>Managed OpenShift</summary>

  - [IBM Cloud - ROKS](https://cloud.ibm.com/kubernetes/catalog/create?platformType=openshift)
  - [AWS - ROSA](https://aws.amazon.com/rosa/)

</details>

*CLI tools*

  - Install the OpenShift CLI oc (version 4.10+) .  The binary can be downloaded from the Help menu from the OpenShift Console.

    <details>
    <summary>Download oc cli</summary>

    ![oc cli](doc/images/oc-cli.png)
    </details>

  - Install helm and kubeseal from brew.sh

   ```bash
   brew install kubeseal && brew install helm
   ```

  - Log in from a terminal window.

    ```bash
    oc login --token=<token> --server=<server>
    ```

### Installation

1. Installation steps will go here
2. Clone the repo
   ```sh
   git clone https://github.com/one-touch-provisioning/otp-gitops.git
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Include usage examples here.

_For more examples, please refer to the [Documentation](https://github.com/one-touch-provisioning/otp-gitops/docs)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3
    - [ ] Nested Feature

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

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Ben Swinney - [@twitter_handle](https://twitter.com/twitter_handle)
Cong Nguyen - [@twitter_handle](https://twitter.com/twitter_handle)
Nick Merrett - [@twitter_handle](https://twitter.com/twitter_handle)
Marwan Attar - [@twitter_handle](https://twitter.com/twitter_handle)
Langley Millard - [@twitter_handle](https://twitter.com/twitter_handle) 

Project Link: [https://github.com/one-touch-provisioning/otp-gitops](https://github.com/one-touch-provisioning/otp-gitops)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

This asset has been built on the shoulders of giants and leverages the great work and effort undertaken by the teams/individuals below. Without these efforts, then this pattern would have struggled to get off the ground.

The reference architecture for this GitOps workflow can be found [here](https://cloudnativetoolkit.dev/adopting/use-cases/gitops/gitops-ibm-cloud-paks/).

* [Cloud Native Toolkit - GitOps Production Deployment Guide](https://github.com/cloud-native-toolkit/multi-tenancy-gitops)
* [IBM Garage TSA](https://github.com/ibm-garage-tsa/cp4mcm-installer)
* [Red Hat Communities of Practice](https://github.com/redhat-cop)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/github_username/repo_name.svg?style=for-the-badge
[contributors-url]: https://github.com/one-touch-provisioning/otp-gitops/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/github_username/repo_name.svg?style=for-the-badge
[forks-url]: https://github.com/one-touch-provisioning/otp-gitops/network/members
[stars-shield]: https://img.shields.io/github/stars/github_username/repo_name.svg?style=for-the-badge
[stars-url]: https://github.com/one-touch-provisioning/otp-gitops/stargazers
[issues-shield]: https://img.shields.io/github/issues/github_username/repo_name.svg?style=for-the-badge
[issues-url]: https://github.com/one-touch-provisioning/otp-gitops/issues
[license-shield]: https://img.shields.io/github/license/github_username/repo_name.svg?style=for-the-badge
[license-url]: https://github.com/one-touch-provisioning/otp-gitops/blob/master/LICENSE
[product-screenshot]: doc/images/ztp.png