# Red Hat Advanced Cluster Management Hub and Spoke Clusters Concepts

## Overview

This pattern leverages two powerful open-source technologies to deliver robust cluster management capabilities:

- **ArgoCD** (also known as OpenShift GitOps): For GitOps-based continuous delivery
- **Open Cluster Management** (also known as Red Hat Advanced Cluster Management or RHACM): For comprehensive cluster lifecycle management

## Understanding the Architecture

At the heart of RHACM lies a Hub and Spoke architecture that provides centralized management of multiple clusters. The Hub Cluster, running RHACM, serves as the control center, offering:

- Cluster lifecycle management
- Application lifecycle management
- Governance and policy enforcement
- Comprehensive observability
- Centralized control of all Spoke Clusters

## Visual Representation

Below is a visual representation of a typical Hub and Spoke deployment across multiple cloud environments:

<div align="center">
  <img src="images/hubandspoke.png" alt="Hub and Spoke Architecture Diagram" width="600" height="600">
</div>

## Why Choose This Pattern?

This architecture provides several key benefits:

- **Centralized Management**: Manage multiple clusters from a single control point
- **Consistent Operations**: Apply uniform policies and configurations across all clusters
- **Enhanced Security**: Implement and monitor security policies across your entire cluster fleet
- **Simplified Observability**: Get a unified view of your entire cluster landscape

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>