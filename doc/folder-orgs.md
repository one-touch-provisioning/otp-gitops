# Use-cases for a different Git Repository folder organisation
  
As our method/pattern matures, we have identified various use cases where a different Git repository folder organization is necessary.

We believe that by leveraging 1 + 5 + n Git repositories approach, which can be read <a href="https://github.com/one-touch-provisioning/otp-gitops/blob/master/doc/git-repo-context.md">here</a>, we can provide more flexibility in deploying configurations and applications into clusters and thus achieve better scalability.

With this approach, the Line of Business, Product Team, end-users, etc. can have full control over their own ArgoCD instance, which is configured against a Git repository that they manage. This enables greater privacy and security since they can control who can view the objects within their repository. We refer to this as a `self-managed cluster`", which is best suited for a team with experience in OpenShift, a clear understanding of their requirements, and comfortable managing the environment themselves.

However, there are occasions where end-users prefer a `managed` model. These users understand their applications and prefer to focus only on those aspects, leaving the management of the cluster to another team. In this scenario, it makes sense to manage the cluster and its applications through a single mono repository, in our example, this would be the Hub Bootstrap respository. Think of this as a `shared-multi-tenancy` operational model, where everyone with access to the Git repository can view all the objects. To demonstrate this model, we have provided example folder structures for the `managed` use case, which can be found in `0-bootstrap/spokeclusters/`.

It is important to note that these are just a few methods for managing environments, and we encourage you to choose the one that works best for you.

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>