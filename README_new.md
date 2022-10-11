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
    <a href="https://github.com/one-touch-provisioning/otp-gitops">OTP Capabilities</a>
    | 
    <a href="https://github.com/one-touch-provisioning/otp-gitops/issues">Report Bug</a>
    |
    <a href="https://github.com/one-touch-provisioning/otp-gitops/issues">Request Feature</a>
    </h3>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
## Table of Contents
  
  <ol>
  <li><a href="#about-the-project">About The Project</a></li>
  <li><a href="#getting-started">Getting Started</a></li>
  <li><a href="#prerequisites">Prerequisites</a></li>
  <li><a href="#installation">Installation</a></li>
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
## About The Project

<div align="center">
  <img src="doc/images/ztp.png" alt="One Touch Provisioning" width="850" height="500">
</div>

This method/pattern is our opinionated implementation of the GitOps principles, using the latest and greatest tooling available, to enable the hitting of one big red button (figuratively) to start provisioning a platform that provides Cluster and Virtual Machine Provisioning capabilities, Governance and policy management, observability of Clusters and workloads and finally deployment of applications, such as IBM Cloud Paks, all within a single command*.

The pattern leans very heavily on technologies such as Red Hat Advanced Cluster Management (RHACM) and OpenShift GitOps (ArgoCD), enabling a process upon which OpenShift clusters, their applications, governance and policies are defined in Git repositories and by leveraging RHACM as a function of OpenShift GitOps, enables the seamless end to end provisioning of those environments.

- Codified, Repeatable and Auditable.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

Before Getting Started with this pattern, it's important to understand some of the concepts and technologies used. This will help reduce the barrier of entry when adopting the pattern and help understand why certain design decisions were made.

  <ul>
    <li><a href="docs/hubandspoke-concepts.md">Red Hat Advanced Cluster Management Hub and Spoke Clusters Concepts</a></li>
    <li><a href="docs/git-repo-context.md">Git Repositories Context</a></li>
    <li><a href="docs/folder-orgs.md">Use-cases for a different Git Repository folder organisation</a></li>
  </ul>
  
## Prerequisites

*Red Hat OpenShift Cluster*

Minimum OpenShift v4.10+ is required.

Deploy a "vanilla" Red Hat OpenShift cluster using either IPI (Installer Provisioned Infrastructure), UPI (User Provisioned Infrastructure), OAS (OpenShift Assisted Service) methods or a Managed OpenShift offering like AWS ROSA, Azure ARO or IBM Cloud - ROKS.

<ul>
    <li><a href="docs/ipi-options.md">IPI</a></li>
    <li><a href="docs/upi-options.md">UPI</a></li>
    <li><a href="docs/managed-ocp-options.md">Managed OpenShift Offerings</a></li>
</ul>

<br />
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

Distributed under the APACHE 2.0 License. See `LICENSE` for more information.

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