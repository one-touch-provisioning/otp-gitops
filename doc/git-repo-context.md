# Git Repositories Context

Our pattern for managing OpenShift Clusters, Applications, and Policies at scale is based on a decentralised approach that allows teams to work together effectively. Rather than relying on a single mono repository, we use multiple repositories that reflect the ownership and contributions of various personas. By doing this, we ensure that the configurations are fully replicated across all the environment, regardless of their location.


For instance, taking the Kubernetes Ownership Model, we looked at which personas would typically contribute and have ownership over a repository and separated a single mono repository into several to reflect that. An example would be a Platform team that primarily contributes and has ownership over a repository that defines the [infrastructure-related](https://github.com/one-touch-provisioning/otp-gitops-infra) components of a Kubernetes Cluster, e.g. namespaces, machinesets, ingress-controllers, storage etc, they may also be best placed to contribute and own a repository that defines how OpenShift [Clusters](https://github.com/one-touch-provisioning/otp-gitops-clusters) are created on different Cloud Providers. Similar examples can be given for a set of Services which support Application developers, where we would separate these into their own repositories, again owned and primarily contributed by a Services team. A Risk/Security team owning and primarily contributing to a [Policies](https://github.com/one-touch-provisioning/otp-gitops-policies) repository is another example.

We enable these repositories as centralised repositories at an organisational, business or product level, where each OpenShift Cluster, including the Hub Cluster, is deployed with OpenShift GitOps (aka ArgoCD). This allows for easy management and ensures that deployed OpenShift Clusters share the same configuration, reducing duplicated code, and maintaining conformance.

Our approach allows for a lower barrier to entry for developers as they can easily access and understand the Git repositories, thereby reducing costs for change and opening up opportunities for innovation

  For our pattern, we've termed the above 1 + 5 + n Git Repositories.

  * 1 Repository being the Red Hat Advanced Cluster Management Hub Cluster

  * 5 Repositories (Infrastructure, Services, Applications, Clusters, Policies) being common / shared

  * n Repository being the repository that you will use to bootstrap your deployed managed OpenShift Cluster

Our approach ensures a scalable and efficient way to manage OpenShift Clusters, Applications, and Policies at scale.

  <div align="center">
    <img src="images/15n-repos.gif" alt="1+5+n Repositories">
  </div>
 
<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>