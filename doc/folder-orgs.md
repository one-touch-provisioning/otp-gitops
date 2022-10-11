# Use-cases for a different Git Repository folder organisation
  
  As we mature this method/pattern, we have seen different use-cases where the need for a different Git Repository folder organisation has been required.

  Our view by leveraging the 1 + 5 + n Git Repositories it allows more flexability to what is deployed into cluster and works better at scale. The Line of Business, Product team, end-users etc can have full control via their own ArgoCD instance which is configured against a Git repository they control. This works for privacy and security as they control who can and cannot see the objects within their repository. We'll term this a `self-managed Cluster`. This may suit a team which has experience in OpenShift, clearly understand their requirements, and are comfortable managing the environment themselves.

  However there are occassions where there maybe a requirement for a Cluster to be provisioned and the end-users wish for a more `managed cluster`. They understand their applications, and prefer to just focus on those aspects. They are happy to commit to a Git Repository that they do not own and prefer that management of the Cluster is owned by another team. In this scenario, it would make sense to manage the cluster and its applications via the Hub Repository alone. Think of this as a `shared-multi-tenancy` operational model. Everyone with access to the Git repository can see all objects within. To demo this model, we've left example folder structures for the `managed` use-case. This can be found in `0-bootstrap/spokeclusters/`.

  It should be noted that these are just a few methods to manage your environments, and we encourage you to choose a method that works for you.

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>