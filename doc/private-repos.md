# OpenShift GitOps with Private Repositories

The following steps will need to repeated for each private repository.

- Generate GitHub Token
  - Visit [https://github.com/settings/tokens](https://github.com/settings/tokens) and select "Generate new token". Give your token a name, an expiration date and select the scope. The token will need to have repo access.

  ![Create a GitHub Secret](images/github-token-scope.png)

  - Click on "Generate token" and copy your token! You will not get another chance to copy your token and you will need to regenerate if you missed to opportunity.

- Generate OpenShift GitOps Namespace

  ```sh
  oc apply -f setup/setup/0_openshift-gitops-namespace.yaml
  ```

- Generate Secret
  - export the GitHub token you copied earlier.

    ```sh
    export GITHUB_TOKEN=<insert github token>
     export GIT_ORG=<git organisation>
    ```

  - Create a secret that will reside within the `openshift-gitops` namespace.

    ```sh
    mkdir repo-secrets
    cat <<EOF > setup/ocp/repo-secrets/otp-gitops-repo-secret.yaml
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

  ```sh
  oc apply -f setup/ocp/repo-secrets/
  rm -rf setup/ocp/repo-secrets
  ```

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>
