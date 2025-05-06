# OpenShift GitOps with Private Repositories

This guide will walk you through the process of configuring OpenShift GitOps to work with private GitHub repositories. Follow these steps for each private repository you want to integrate.

## Prerequisites
- Access to an OpenShift cluster
- GitHub account with access to the private repositories
- OpenShift CLI (`oc`) installed and configured

## Step 1: Generate a GitHub Personal Access Token
1. Navigate to [GitHub Personal Access Tokens](https://github.com/settings/tokens)
2. Click "Generate new token"
3. Configure the token with:
   - A descriptive name
   - Appropriate expiration date
   - Required scopes (minimum: `repo` access)
   
   ![GitHub Token Scope Selection](images/github-token-scope.png)

4. Click "Generate token" and **immediately copy your token**. This is your only chance to view it!

## Step 2: Set Up OpenShift GitOps Namespace
Apply the namespace configuration:
```sh
oc apply -f setup/setup/0_openshift-gitops-namespace.yaml
```

## Step 3: Create Repository Secrets
1. Set up your environment variables:
   ```sh
   export GITHUB_TOKEN=<your-github-token>
   export GIT_ORG=<your-github-organization>
   ```

2. Create the secrets directory:
   ```sh
   mkdir -p setup/ocp/repo-secrets
   ```

3. Generate secrets for each repository. Here's an example for the main repository:
   ```sh
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

4. Repeat the secret creation for these additional repositories:
   - `otp-gitops-infra`
   - `otp-gitops-services`
   - `otp-gitops-policies`
   - `otp-gitops-clusters`
   - `otp-gitops-apps`

## Step 4: Apply Secrets to OpenShift
Apply all generated secrets to your cluster:
```sh
oc apply -f setup/ocp/repo-secrets/
rm -rf setup/ocp/repo-secrets
```

## Next Steps
After completing these steps, your OpenShift GitOps instance will be able to access and manage your private repositories. You can now proceed with configuring your GitOps workflows.

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>
