# Install and configure OpenShift GitOps

- [Red Hat OpenShift GitOps](https://docs.openshift.com/container-platform/4.10/cicd/gitops/understanding-openshift-gitops.html) uses [Argo CD](https://argoproj.github.io/argo-cd/), an open-source declarative tool, to maintain and reconcile cluster resources.

1. Install the OpenShift GitOps Operator and create a `ClusterRole` and `ClusterRoleBinding`.

   ```bash
   oc apply -f setup/
   while ! oc wait crd applications.argoproj.io --timeout=-1s --for=condition=Established  2>/dev/null; do sleep 30; done
   while ! oc wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n openshift-gitops > /dev/null; do sleep 30; done
   ```

2. Create a custom ArgoCD instance with custom checks

   ```bash
   oc apply -k argocd-instance
   ```

   _Note:_ We use a custom openshift-gitops-repo-server image to enable the use of Plugins within OpenShift Gitops. This is required to allow RHACM to utilise the Policy Generator plugin. The Dockerfile can be found here: [https://github.com/one-touch-provisioning/otp-custom-argocd-repo-server](https://github.com/one-touch-provisioning/otp-custom-argocd-repo-server).

3. If using IBM Cloud ROKS as a Hub Cluster, configure TLS.

   ```bash
   scripts/patch-argocd-tls.sh
   ```

4. Create a console link

   ```bash
   export ROUTE_NAME=openshift-gitops-cntk-server
   export ROUTE_NAMESPACE=openshift-gitops
   export CONSOLE_LINK_URL="https://$(oc get route $ROUTE_NAME -o=jsonpath='{.spec.host}' -n $ROUTE_NAMESPACE)"
   envsubst < <(cat setup/4_consolelink.yaml.envsubst) | oc apply -f -
   ```

5. Retrieve admin login details

   ```bash
   echo $(oc get route -n openshift-gitops openshift-gitops-cntk-server -o template --template='https://{{.spec.host}}')

   # Passsword is not needed if Log In via OpenShift is used (default)
   oc extract secrets/openshift-gitops-cntk-cluster --keys=admin.password -n openshift-gitops --to=-
   ```
