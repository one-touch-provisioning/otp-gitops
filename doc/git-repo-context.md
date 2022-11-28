# Git Repositories Context
  
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

  <div align="center">
    <img src="images/15n-repos.gif" alt="1+5+n Repositories">
  </div>
 
  By using a common set of repositories we can quickly scale out Cluster Deployments and reducing the risk of misconfiguration and drift.

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>