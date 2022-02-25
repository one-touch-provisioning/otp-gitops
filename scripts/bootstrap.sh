#!/usr/bin/env bash

set -eo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ -n "${DEBUG:-}" ]] && set -x

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

command -v gh >/dev/null 2>&1 || { echo >&2 "The Github CLI gh but it's not installed. Download https://github.com/cli/cli "; exit 1; }

set +e
oc version --client | grep '4.7\|4.8'
OC_VERSION_CHECK=$?
set -e
if [[ ${OC_VERSION_CHECK} -ne 0 ]]; then
  echo "Please use oc client version 4.7 or 4.8 download from https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/ "
fi


if [[ -z ${GIT_ORG} ]]; then
  echo "We recommend to create a new github organization for all your gitops repos"
  echo "Setup a new organization on github https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch"
  echo "Please set the environment variable GIT_ORG when running the script like:"
  echo "GIT_ORG=acme-org OUTPUT_DIR=gitops-production ./scripts/bootstrap.sh"

  exit 1
fi

if [[ -z ${OUTPUT_DIR} ]]; then
  echo "Please set the environment variable OUTPUT_DIR when running the script like:"
  echo "GIT_ORG=acme-org OUTPUT_DIR=gitops-production ./scripts/bootstrap.sh"

  exit 1
fi
mkdir -p "${OUTPUT_DIR}"


CP_DEFAULT_TARGET_NAMESPACE=${CP_DEFAULT_TARGET_NAMESPACE:-tools}

GITOPS_PROFILE=${GITOPS_PROFILE:-0-bootstrap}

GIT_BRANCH=${GIT_BRANCH:-master}
GIT_BASEURL=${GIT_BASEURL:-https://github.com}
GIT_GITOPS=${GIT_GITOPS:-otp-gitops.git}
GIT_GITOPS_BRANCH=${GIT_GITOPS_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_INFRA=${GIT_GITOPS_INFRA:-otp-gitops-infra.git}
GIT_GITOPS_INFRA_BRANCH=${GIT_GITOPS_INFRA_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_SERVICES=${GIT_GITOPS_SERVICES:-otp-gitops-services.git}
GIT_GITOPS_SERVICES_BRANCH=${GIT_GITOPS_SERVICES_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_APPLICATIONS=${GIT_GITOPS_APPLICATIONS:-otp-gitops-apps.git}
GIT_GITOPS_APPLICATIONS_BRANCH=${GIT_GITOPS_APPLICATIONS_BRANCH:-${GIT_BRANCH}}


IBM_CP_IMAGE_REGISTRY=${IBM_CP_IMAGE_REGISTRY:-cp.icr.io}
IBM_CP_IMAGE_REGISTRY_USER=${IBM_CP_IMAGE_REGISTRY_USER:-cp}

fork_repos () {
    echo "Github user/org is ${GIT_ORG}"

    pushd ${OUTPUT_DIR}

    GHREPONAME=$(gh api /repos/${GIT_ORG}/otp-gitops -q .name || true)
    if [[ ! ${GHREPONAME} = "otp-gitops" ]]; then
      echo "Fork not found, creating fork and cloning"
      gh repo fork one-touch-provisioning/otp-gitops --clone --org ${GIT_ORG} --remote
    elif [[ ! -d otp-gitops ]]; then
      echo "Fork found, repo not cloned, cloning repo"
      gh repo clone ${GIT_ORG}/otp-gitops otp-gitops
    fi
    cd otp-gitops
    git remote set-url --push upstream no_push
    git checkout ${GIT_GITOPS_BRANCH} || git checkout --track origin/${GIT_GITOPS_BRANCH}
    cd ..

    GHREPONAME=$(gh api /repos/${GIT_ORG}/otp-gitops-infra -q .name || true)
    if [[ ! ${GHREPONAME} = "otp-gitops-infra" ]]; then
      echo "Fork not found, creating fork and cloning"
      gh repo fork one-touch-provisioning/otp-gitops-infra --clone --org ${GIT_ORG} --remote
    elif [[ ! -d otp-gitops-infra ]]; then
      echo "Fork found, repo not cloned, cloning repo"
      gh repo clone ${GIT_ORG}/otp-gitops-infra otp-gitops-infra
    fi
    cd otp-gitops-infra
    git remote set-url --push upstream no_push
    git checkout ${GIT_GITOPS_INFRA_BRANCH} || git checkout --track origin/${GIT_GITOPS_INFRA_BRANCH}
    cd ..

    GHREPONAME=$(gh api /repos/${GIT_ORG}/otp-gitops-services -q .name || true)
    if [[ ! ${GHREPONAME} = "otp-gitops-services" ]]; then
      echo "Fork not found, creating fork and cloning"
      gh repo fork one-touch-provisioning/otp-gitops-services --clone --org ${GIT_ORG} --remote
    elif [[ ! -d otp-gitops-services ]]; then
      echo "Fork found, repo not cloned, cloning repo"
      gh repo clone ${GIT_ORG}/otp-gitops-services otp-gitops-services
    fi
    cd otp-gitops-services
    git remote set-url --push upstream no_push
    git checkout ${GIT_GITOPS_SERVICES_BRANCH} || git checkout --track origin/${GIT_GITOPS_SERVICES_BRANCH}
    cd ..

    GHREPONAME=$(gh api /repos/${GIT_ORG}/otp-gitops-apps -q .name || true)
    if [[ ! ${GHREPONAME} = "otp-gitops-apps" ]]; then
      echo "Fork not found, creating fork and cloning"
      gh repo fork one-touch-provisioning/otp-gitops-apps --clone --org ${GIT_ORG} --remote
    elif [[ ! -d otp-gitops-apps ]]; then
      echo "Fork found, repo not cloned, cloning repo"
      gh repo clone ${GIT_ORG}/otp-gitops-apps otp-gitops-apps
    fi
    cd otp-gitops-apps
    git remote set-url --push upstream no_push
    git checkout ${GIT_GITOPS_APPLICATIONS_BRANCH} || git checkout --track origin/${GIT_GITOPS_APPLICATIONS_BRANCH}
    cd ..

    popd

}

check_infra () {
   if [[ "${ADD_INFRA}" == "yes" ]]; then 
     pushd ${OUTPUT_DIR}/otp-gitops
       source ./scripts/infra-mod.sh
     popd
   fi
}

install_argocd () {
    echo "Installing OpenShift GitOps Operator for OpenShift"
    pushd ${OUTPUT_DIR}
    oc apply -f otp-gitops/setup/ocp/
    while ! oc wait crd applications.argoproj.io --timeout=-1s --for=condition=Established  2>/dev/null; do sleep 30; done
    while ! oc wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n openshift-gitops > /dev/null; do sleep 30; done
    popd
}

create_custom_argocd_instance () {
    echo "Create a custom ArgoCD instance with custom checks"
    pushd ${OUTPUT_DIR}

    oc apply -f otp-gitops/setup/ocp/argocd-instance/ -n openshift-gitops
    while ! oc wait pod --timeout=-1s --for=condition=ContainersReady -l app.kubernetes.io/name=openshift-gitops-cntk-server -n openshift-gitops > /dev/null; do sleep 30; done
    popd
}

create_argocd_git_override_configmap () {
echo "Creating argocd-git-override configmap file ${OUTPUT_DIR}/argocd-git-override-configmap.yaml"
pushd ${OUTPUT_DIR}

cat <<EOF >argocd-git-override-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-git-override
data:
  map.yaml: |-
    map:
    - upstreamRepoURL: \${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS}
      originRepoUrL: ${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS}
      originBranch: ${GIT_GITOPS_BRANCH}
    - upstreamRepoURL: \${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_INFRA}
      originRepoUrL: ${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_INFRA}
      originBranch: ${GIT_GITOPS_INFRA_BRANCH}
    - upstreamRepoURL: \${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_SERVICES}
      originRepoUrL: ${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_SERVICES}
      originBranch: ${GIT_GITOPS_SERVICES_BRANCH}
    - upstreamRepoURL: \${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_APPLICATIONS}
      originRepoUrL: ${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_APPLICATIONS}
      originBranch: ${GIT_GITOPS_APPLICATIONS_BRANCH}
EOF

popd
}

apply_argocd_git_override_configmap () {
  echo "Applying ${OUTPUT_DIR}/argocd-git-override-configmap.yaml"
  pushd ${OUTPUT_DIR}

  oc apply -n openshift-gitops -f argocd-git-override-configmap.yaml

  popd
}
argocd_git_override () {
  echo "Deploying argocd-git-override webhook"
  oc apply -n openshift-gitops -f https://github.com/csantanapr/argocd-git-override/releases/download/v1.1.0/deployment.yaml
  oc apply -f https://github.com/csantanapr/argocd-git-override/releases/download/v1.1.0/webhook.yaml
  oc label ns openshift-gitops cntk=experiment --overwrite=true
  sleep 5
  oc wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n openshift-gitops > /dev/null
}

deploy_bootstrap_argocd () {
  echo "Deploying top level bootstrap ArgoCD Application for cluster profile ${GITOPS_PROFILE}"
  pushd ${OUTPUT_DIR}
  oc apply -n openshift-gitops -f otp-gitops/${GITOPS_PROFILE}/bootstrap.yaml
  popd
}


update_pull_secret () {
  # Only applicable when workers reload automatically
  if [[ -z "${IBM_ENTITLEMENT_KEY}" ]]; then
    echo "Please pass the environment variable IBM_ENTITLEMENT_KEY"
    exit 1
  fi
  WORKDIR=$(mktemp -d)
  # extract using oc get secret
  oc get secret/pull-secret -n openshift-config --template='{{index .data ".dockerconfigjson" | base64decode}}' >${WORKDIR}/.dockerconfigjson
  ls -l ${WORKDIR}/.dockerconfigjson

  # or extract using oc extract
  #oc extract secret/pull-secret --keys .dockerconfigjson -n openshift-config --confirm --to=-
  #oc extract secret/pull-secret --keys .dockerconfigjson -n openshift-config --confirm --to=./foo
  #ls -l ${WORKDIR}/.dockerconfigjson

  # merge a new entry into existing file
  oc registry login --registry="${IBM_CP_IMAGE_REGISTRY}" --auth-basic="${IBM_CP_IMAGE_REGISTRY_USER}:${IBM_ENTITLEMENT_KEY}" --to=${WORKDIR}/.dockerconfigjson
  #cat ${WORKDIR}/.dockerconfigjson

  # write back into cluster, but is better to save it to gitops repo :-)
  oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=${WORKDIR}/.dockerconfigjson

  # TODO: Check if reboot is done automatically?

  # get back the yaml merged to save it in gitops git repo to be deploy with ArgoCD
  #oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=${WORKDIR}/.dockerconfigjson  --dry-run=client -o yaml
}

set_pull_secret () {

  if [[ -z "${IBM_ENTITLEMENT_KEY}" ]]; then
    echo "Please pass the environment variable IBM_ENTITLEMENT_KEY"
    exit 1
  fi
  oc new-project ${CP_DEFAULT_TARGET_NAMESPACE} || true
  oc create secret docker-registry ibm-entitlement-key -n ${CP_DEFAULT_TARGET_NAMESPACE} \
  --docker-username="${IBM_CP_IMAGE_REGISTRY_USER}" \
  --docker-password="${IBM_ENTITLEMENT_KEY}" \
  --docker-server="${IBM_CP_IMAGE_REGISTRY}" || true
}

init_sealed_secrets () {

  echo "Intializing sealed secrets with file ${SEALED_SECRET_KEY_FILE}"
  oc new-project sealed-secrets || true
  oc apply -f ${SEALED_SECRET_KEY_FILE}

}


print_urls_passwords () {

    echo "# Openshift Console UI: $(oc whoami --show-console)"
    echo "# "
    echo "# Openshift ArgoCD/GitOps UI: $(oc get route -n openshift-gitops openshift-gitops-cntk-server -o template --template='https://{{.spec.host}}')"
    echo "# "
    echo "# To get the ArgoCD/GitOps URL and admin password:"
    echo "# -----"
    echo "oc get route -n openshift-gitops openshift-gitops-cntk-server -o template --template='https://{{.spec.host}}'"
    echo "oc extract secrets/openshift-gitops-cntk-cluster --keys=admin.password -n openshift-gitops --to=-"
    echo "# -----"

}

get_rwx_storage_class () {

  DEFAULT_RWX_STORAGE_CLASS=${DEFAULT_RWX_STORAGE_CLASS:-managed-nfs-storage}
  OCS_RWX_STORAGE_CLASS=${OCS_RWX_STORAGE_CLASS:-ocs-storagecluster-cephfs}

  if [[ -n "${RWX_STORAGE_CLASS}" ]]; then
    echo "RWX Storage class specified to ${RWX_STORAGE_CLASS}"
    return 0
  fi
  set +e
  oc get sc -o jsonpath='{.items[*].metadata.name}' | grep "${OCS_RWX_STORAGE_CLASS}"
  OC_SC_OCS_CHECK=$?
  set -e
  if [[ ${OC_SC_OCS_CHECK} -eq 0 ]]; then
    echo "Found OCS RWX storage class"
    RWX_STORAGE_CLASS="${OCS_RWX_STORAGE_CLASS}"
    return 0
  fi
  RWX_STORAGE_CLASS=${DEFAULT_RWX_STORAGE_CLASS}
}

set_rwx_storage_class () {

  if [[ ${RWX_STORAGE_CLASS} = ${DEFAULT_RWX_STORAGE_CLASS} ]]; then
    echo "Using default RWX storage managed-nfs-storage skipping override"
    return 0
  fi

  echo "Replacing ${DEFAULT_RWX_STORAGE_CLASS} with ${RWX_STORAGE_CLASS} storage class "
  pushd ${OUTPUT_DIR}/otp-gitops/

  find . -name '*.yaml' -print0 |
    while IFS= read -r -d '' File; do
      if grep -q "${DEFAULT_RWX_STORAGE_CLASS}" "$File"; then
        #echo "$File"
        sed -i'.bak' -e "s#${DEFAULT_RWX_STORAGE_CLASS}#${RWX_STORAGE_CLASS}#" $File
        rm "${File}.bak"
      fi
    done

  git --no-pager diff

  git add .

  git commit -m "Change RWX storage class to ${RWX_STORAGE_CLASS}"

  git push origin

  popd
}


# main

fork_repos

if [[ -n "${IBM_ENTITLEMENT_KEY}" ]]; then
  update_pull_secret
  set_pull_secret
fi

if [[ -n "${SEALED_SECRET_KEY_FILE}" ]]; then
  init_sealed_secrets
fi

check_infra

install_argocd

create_custom_argocd_instance

create_argocd_git_override_configmap

apply_argocd_git_override_configmap

argocd_git_override

# Set RWX storage
get_rwx_storage_class
set_rwx_storage_class

deploy_bootstrap_argocd

print_urls_passwords

exit 0



