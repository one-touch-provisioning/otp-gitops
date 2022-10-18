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
    One Touch Provisioning (OTP) is a pattern that enables the seamless end-to-end provisioning of Red Hat OpenShift clusters, their applications, governance and policies to Public, Private and On-Premise Clouds all via Code.
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
  <li><a href="#about-the-project">About The Project</a></li>
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
## About The Project

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

Install the OpenShift CLI oc (version 4.10+).  The binary can be downloaded from the Help menu from the OpenShift cluster console, or downloaded from the [OpenShift Mirror](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/) website.

##### Helm and KubeSeal

Install helm and kubeseal from brew.sh

 ```sh
  brew install kubeseal && brew install helm
 ```

#### Overview of git repositories

The pattern requires the use of six git repositories within the GitOps workflow, the reason for this is explained <a href="doc/git-repo-context.md">here</a>.

- RHACM Hub GitOps repository ([https://github.com/one-touch-provisioning/otp-gitops](https://github.com/one-touch-provisioning/otp-gitops))
  - This repository contains all the ArgoCD Applications for the `infrastructure`, `services`, `policies`, `clusters` and `application` layers. Each ArgoCD Application will reference a specific resource that will be deployed to the RHACM Hub Cluster, or depending on your chosen configuration, it may include Spoke Cluster resources as well.

- Infrastructure GitOps repository ([https://github.com/one-touch-provisioning/otp-gitops-infra](https://github.com/one-touch-provisioning/otp-gitops-infra))
  - This repository is what we've termed a "common repository". This repository will be used across both the RHACM Hub cluster and any Spoke clusters you deploy. The repository contains the YAMLs for cluster-wide and/or infrastructure related resources managed by a cluster administrator.  This would include `namespaces`, `clusterroles`, `clusterrolebindings`, `machinesets` to name a few. By leveraging "common repositories", you can reduce depulication of code and ensure a consistant set of resources are applied each time.

- Services GitOps repository ([https://github.com/one-touch-provisioning/otp-gitops-services](https://github.com/one-touch-provisioning/otp-gitops-services))
  - This repository is what we've termed a "common repository". This repository will be used across both the RHACM Hub cluster and any Spoke clusters you deploy. The repository contains the YAMLs for resources which will be used by the RHACM Hub and Spoke clusters.  This repository include `subscriptions` for Operators, YAMLs of custom resources provided, or Helm Charts for tools provided by a third party. These resource would usually be managed by the Administrator(s) and/or a DevOps team supporting application developers. By leveraging "common repositories", you can reduce depulication of code and ensure a consistant set of resources are applied each time.

- Policies GitOps repository ([https://github.com/one-touch-provisioning/otp-gitops-policies](https://github.com/one-touch-provisioning/otp-gitops-policies))
  - This repository is what we've termed a "common repository". The repository contains the YAMLs for resources to deploy `Policies` to both the RHACM Hub and Spoke clusters. These resource would usually be managed by the GRC and/or Security teams. By leveraging "common repositories", you can reduce depulication of code and ensure a consistant set of resources are applied each time.

- Clusters GitOps repository ([https://github.com/one-touch-provisioning/otp-gitops-clusters](https://github.com/one-touch-provisioning/otp-gitops-clusters))
  - This repository is what we've termed a "common repository". The repository contains the YAMLs for resources to deploy `OpenShift Clusters`. These resource would usually be managed by the Platform Administrator(s) and/or a Ops team supporting the Cloud Platforms. By leveraging "common repositories", you can reduce depulication of code and ensure a consistant set of resources are applied each time.

- Apps GitOps repository ([https://github.com/one-touch-provisioning/otp-gitops-apps](https://github.com/one-touch-provisioning/otp-gitops-apps))
  - This repository is what we've termed a "common repository". The repository contains the YAMLs for resources to deploy the RHACM Hub or Spoke `OpenShift Clusters`. Contains the YAMLs for resources to deploy `applications`. By leveraging "common repositories", you can reduce depulication of code and ensure a consistant set of resources are applied each time.

#### Setup of git repositories

1. Create a new GitHub Organization using instructions from this [GitHub documentation](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch).

2. From each template repository, click the `Use this template` button and create a copy of the repository in your new GitHub Organization.

    ![Create repository from a template](doc/images/git-repo-template-button.png)

3. (Optional) OpenShift GitOps can leverage GitHub tokens. Many users may wish to use private Git repositories on GitHub to store their manifests, rather than leaving them publically readable. The following steps will need to repeated for each repository.

    - Generate GitHub Token
      - Visit [https://github.com/settings/tokens](https://github.com/settings/tokens) and select "Generate new token". Give your token a name, an expiration date and select the scope. The token will need to have repo access.

        ![Create a GitHub Secret](doc/images/github-token-scope.png)

      - Click on "Generate token" and copy your token! You will not get another chance to copy your token and you will need to regenerate if you missed to opportunity.

    - Generate OpenShift GitOps Namespace

       ```bash
       oc apply -f setup/setup/0_openshift-gitops-namespace.yaml
       ```

    - Generate Secret
      - export the GitHub token you copied earlier.

        ```bash
        $ export GITHUB_TOKEN=<insert github token>
        $ export GIT_ORG=<git organisation>
        ```

      - Create a secret that will reside within the `openshift-gitops` namespace.

        ```bash
        $ mkdir repo-secrets
        $ cat <<EOF > setup/ocp/repo-secrets/otp-gitops-repo-secret.yaml
        apiVersion: v1
        kind: Secret
        metadata:
          name: otp-gitops-repo-secret
          namespace: openshift-gitops
          labels:
            argocd.argoproj.io/secret-type: repository
        stringData:
          url: https://github.com/${GIT_ORG}/otp-gitops
          password: ${GITHUB_TOKEN}
          username: not-used
        EOF
        ```

      - Repeat the above steps for `otp-gitops-infra`, `otp-gitops-services`, `otp-gitops-policies`, `otp-gitops-clusters` and `otp-gitops-apps` repositories.

    - Apply Secrets to the OpenShift Cluster

      ```bash
      oc apply -f setup/ocp/repo-secrets/
      rm -rf setup/ocp/repo-secrets
      ```

4. Clone the repositories locally.

    ```sh
    mkdir -p <gitops-repos>
    cd <gitops-repos>
    
    # Example: set default Git org for clone commands below
    GIT_ORG=one-touch-provisioning

    # Clone using SSH
    git clone git@github.com:$GIT_ORG/otp-gitops.git
    git clone git@github.com:$GIT_ORG/otp-gitops-infra.git
    git clone git@github.com:$GIT_ORG/otp-gitops-services.git
    git clone git@github.com:$GIT_ORG/otp-gitops-policies.git
    git clone git@github.com:$GIT_ORG/otp-gitops-clusters.git
    git clone git@github.com:$GIT_ORG/otp-gitops-apps.git
    ```

5. Update the default Git URl and branch references in your `otp-gitops` repository by running the provided script `./scripts/set-git-source.sh` script.

    ```sh
    cd otp-gitops
    GIT_ORG=<GIT_ORG> GIT_BRANCH=master ./scripts/set-git-source.sh
    git add .
    git commit -m "Update Git URl and branch references"
    git push origin master
    ```

#### IBM Entitlement Key for IBM Cloud Paks

If you intend to deploy the `Infrastructure Automation` component of IBM Cloud Pak for Watson AIOps, then please follow the instructions <a href="docs/ibm-entitlement-key.md">here</a>.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Installation -->
### Installation


<!-- USAGE -->
## Usage

Include usage examples here.

_For more examples, please refer to the [Documentation](https://github.com/one-touch-provisioning/otp-gitops/doc)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [ ] OTP cli
- [ ] Ansible Automation integration with Libvirt and VMWare
- [ ] HyperShift Integration
    - [ ] HyperShift with OpenShift Virtualisation for Worker nodes

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
  <li>Ben Swinney | @bdgsts | Linkedin | Github</li>
  <li>Cong Nguyen | Linkedin | Github</li>
  <li>Nick Merrett | Linkedin | Github</li>
  <li>Marwan Attar | Linkedin | Github</li>
  <li>Langley Millard | Linkedin | Github</li>
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