# Pattern Capabilities

This pattern delivers a comprehensive enterprise-grade OpenShift management solution with the following key features:

## Core Infrastructure
- Deploys an opinionated **Hub Cluster** configuration featuring:
  - Red Hat Advanced Cluster Management (RHACM)
  - OpenShift GitOps (ArgoCD)
  - OpenShift Pipelines (Tekton)
  - OpenShift Data Foundation (Rook.io)
  - Ansible Automation Platform (Additional Subscription required)
  - Red Hat Advanced Cluster Security (Stackrox)
  - Quay Registry with Container Security
  - OpenShift Virtualization (KubeVirt)
  - IBM Infrastructure Automation (IBM Cloud Pak for AIOps 3.2)
  - Instana
  - Turbonomics
  - External Secrets
  - RHACM Observability

## Multi-Cloud Management
- **Infrastructure as Code (IaC)**: Deploy and manage OpenShift clusters across multiple environments:
  - Amazon Web Services (AWS)
  - Microsoft Azure
  - IBM Cloud
  - Google Cloud Platform (GCP)
  - VMware vSphere
  - Bare-metal environments
  - Single Node OpenShift for on-premise deployments

## Cost Optimization
- **Cluster Hibernation**: Automatically hibernate managed OpenShift clusters on AWS, Azure, and GCP when not in use, reducing resource consumption and lowering cloud costs

## Automated Cluster Management
- **Auto-Discovery**: Automatically discover OpenShift clusters using Red Hat OpenShift Cluster Manager credentials
- **Seamless Integration**: Import discovered clusters as managed clusters with automatic OpenShift GitOps configuration

## Centralized Application Management
- **Unified GitOps Control**: Deploy and manage applications across your entire OpenShift fleet
- **Global Visibility**: Monitor and manage applications across all clusters, regardless of their location (cloud or on-premise)

## Enterprise Governance
- **Automated Policy Enforcement**: Apply consistent policies and governance across all managed clusters
- **Cross-Environment Compliance**: Maintain compliance standards across your entire OpenShift estate

## Advanced Infrastructure Management
- **Flexible Instana Deployment**:
  - Self-hosted option using OpenShift Virtualization
  - Automated deployment to IaaS environments via IBM Infrastructure Automation
- **IaaS Integration**: Automatic connection to IaaS environments for streamlined virtual machine deployment
- **Pipeline-Driven Automation**: Deploy virtual machines using IBM Infrastructure Automation and OpenShift Pipelines

## Application Deployment
- **Automated Application Delivery**: Configure automatic application deployment to managed clusters via OpenShift GitOps
- **Reference Implementation**: Includes example deployment of IBM Cloud Pak for Integration using GitOps principles

## Edge Computing Support
- **Zero Touch Provisioning**: Automated deployment of managed OpenShift clusters to bare-metal nodes
- **Edge-Ready**: Supports both near and far edge deployment scenarios

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>