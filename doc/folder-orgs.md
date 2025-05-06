# Git Repository Organization: Flexible Deployment Patterns

As our deployment methodology matures, we've identified various use cases that benefit from different Git repository organization patterns.

Our recommended approach leverages a "1 + 5 + n" Git repositories structure, which you can learn more about in our [Git Repository Context documentation](https://github.com/one-touch-provisioning/otp-gitops/blob/master/doc/git-repo-context.md). This architecture provides enhanced flexibility for deploying configurations and applications into clusters, enabling better scalability and management.

## Deployment Models

### Self-Managed Clusters
This model empowers Line of Business teams, Product Teams, and end-users with complete control over their own ArgoCD instance, configured against a Git repository they manage. Benefits include:
- Enhanced privacy and security through granular access control
- Full autonomy over repository objects and configurations
- Ideal for teams with OpenShift experience and clear operational requirements

### Managed Clusters
For teams that prefer to focus solely on their applications while delegating cluster management, we offer a managed model. In this scenario:
- Cluster and application management is handled through a single mono repository (the Hub Bootstrap repository)
- Operates as a shared-multi-tenancy model
- Perfect for teams wanting to concentrate on application development rather than infrastructure management

## Getting Started
To help you get started, we've provided example folder structures for the managed use case in `0-bootstrap/spokeclusters/`. These examples demonstrate practical implementations of our recommended patterns.

Choose the model that best aligns with your team's expertise and operational needs. Our flexible architecture supports both approaches, allowing you to evolve your deployment strategy as your requirements change.

<p align="right">[Back to main](https://github.com/one-touch-provisioning/otp-gitops/)</p>