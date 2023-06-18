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
oc version --client | grep '4.9\|4.10\|4.11\|4.12\|4.13' >/dev/null 2>&1
OC_VERSION_CHECK=$?
set -e
if [[ ${OC_VERSION_CHECK} -ne 0 ]]; then
  echo "Please use oc client version > 4.10 download from https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/ "
fi

if [[ -z ${GIT_ORG} ]]; then
  echo "We recommend to create a new github organization for all your gitops repos"
  echo "Setup a new organization on github https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch"
  echo "Please set the environment variable GIT_ORG when running the script"
  echo "Example: GIT_ORG=one-touch-provisioning OUTPUT_DIR=one-touch-provisioning ./scripts/create-repos.sh"

  exit 1
fi

if [[ -z ${OUTPUT_DIR} ]]; then
  echo "Please set the environment variable OUTPUT_DIR when running the script"
  echo "Example: GIT_ORG=one-touch-provisioning OUTPUT_DIR=one-touch-provisioning ./scripts/create-repos.sh"

  exit 1
else
  echo "Creating GitHub repositories and local clones in folder:" ${OUTPUT_DIR}
fi
mkdir -p "${OUTPUT_DIR}"

GIT_BRANCH=${GIT_BRANCH:-master}
GIT_PROTOCOL=${GIT_PROTOCOL:-https}
GIT_HOST=${GIT_HOST:-github.com}
GIT_BASEURL=${GIT_BASEURL:-${GIT_PROTOCOL}://${GIT_HOST}}
GIT_GITOPS=${GIT_GITOPS:-otp-gitops.git}
GIT_GITOPS_NAME=otp-gitops
GIT_GITOPS_BRANCH=${GIT_GITOPS_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_INFRA=${GIT_GITOPS_INFRA:-otp-gitops-infra.git}
GIT_GITOPS_INFRA_BRANCH=${GIT_GITOPS_INFRA_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_INFRA_NAME=otp-gitops-infra
GIT_GITOPS_SERVICES=${GIT_GITOPS_SERVICES:-otp-gitops-services.git}
GIT_GITOPS_SERVICES_BRANCH=${GIT_GITOPS_SERVICES_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_SERVICES_NAME=otp-gitops-services
GIT_GITOPS_POLICIES=${GIT_GITOPS_POLICIES:-otp-gitops-policies.git}
GIT_GITOPS_POLICIES_BRANCH=${GIT_GITOPS_POLICIES_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_POLICIES_NAME=otp-gitops-policies
GIT_GITOPS_CLUSTERS=${GIT_GITOPS_CLUSTERS:-otp-gitops-clusters.git}
GIT_GITOPS_CLUSTERS_BRANCH=${GIT_GITOPS_CLUSTERS_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_CLUSTERS_NAME=otp-gitops-clusters
GIT_GITOPS_APPLICATIONS=${GIT_GITOPS_APPLICATIONS:-otp-gitops-apps.git}
GIT_GITOPS_APPLICATIONS_BRANCH=${GIT_GITOPS_APPLICATIONS_BRANCH:-${GIT_BRANCH}}
GIT_GITOPS_APPLICATIONS_NAME=otp-gitops-apps
NEW_FOLDERS=${NEW_FOLDERS}

if [ -z ${NEW_FOLDERS} ]; then
  LOCAL_FOLDER_0="otp-gitops"
  LOCAL_FOLDER_1="otp-gitops-infra"
  LOCAL_FOLDER_2="otp-gitops-services"
  LOCAL_FOLDER_3="otp-gitops-policies"
  LOCAL_FOLDER_4="otp-gitops-clusters"
  LOCAL_FOLDER_5="otp-gitops-apps"
fi

create_repos () {
    echo "Github user/org is ${GIT_ORG}"

    pushd ${OUTPUT_DIR}

    # OTP GITOPS REPO
    GHREPONAME=$(gh api /repos/${GIT_ORG}/otp-gitops -q .name || true)
    if [[ ! ${GHREPONAME} = "otp-gitops" ]]; then
      echo "Repository ${GIT_GITOPS_NAME} not found, creating from template and cloning"
      gh repo create ${GIT_ORG}/otp-gitops --public --template https://github.com/one-touch-provisioning/otp-gitops
      gh repo clone ${GIT_ORG}/otp-gitops
      if [ ! -z ${NEW_FOLDERS} ]; then
        mv otp-gitops ${LOCAL_FOLDER_0}
      fi
    elif [[ ! -d ${LOCAL_FOLDER_0} ]]; then
      echo "Repository ${GIT_GITOPS_NAME} found but not cloned... cloning repository"
      gh repo clone ${GIT_ORG}/otp-gitops ${LOCAL_FOLDER_0}
    else
      echo "Repository ${GIT_GITOPS_NAME} exists and already cloned... nothing to do"
    fi
    cd ${LOCAL_FOLDER_0}
    git checkout ${GIT_GITOPS_BRANCH} || git checkout --track origin/${GIT_GITOPS_BRANCH}
    cd ..

    # OTP GITOPS INFRA REPO
    GHREPONAME=$(gh api /repos/${GIT_ORG}/otp-gitops-infra -q .name || true)
    if [[ ! ${GHREPONAME} = "otp-gitops-infra" ]]; then
      echo "Repository not found for ${GIT_GITOPS_INFRA_NAME}; creating from template and cloning"
      gh repo create ${GIT_ORG}/otp-gitops-infra --public --template https://github.com/one-touch-provisioning/otp-gitops-infra
      gh repo clone ${GIT_ORG}/otp-gitops-infra
      if [ ! -z ${NEW_FOLDERS} ]; then
        mv otp-gitops-infra ${LOCAL_FOLDER_1}
      fi
    elif [[ ! -d ${LOCAL_FOLDER_1} ]]; then
      echo "Repository ${GIT_GITOPS_INFRA_NAME} found but not cloned... cloning repository"
      gh repo clone ${GIT_ORG}/otp-gitops-infra ${LOCAL_FOLDER_1}
    else
      echo "Repository ${GIT_GITOPS_INFRA_NAME} exists and already cloned... nothing to do"
    fi
    cd ${LOCAL_FOLDER_1}
    git checkout ${GIT_GITOPS_INFRA_BRANCH} || git checkout --track origin/${GIT_GITOPS_INFRA_BRANCH}
    cd ..

    # OTP GITOPS SERVICES REPO
    GHREPONAME=$(gh api /repos/${GIT_ORG}/otp-gitops-services -q .name || true)
    if [[ ! ${GHREPONAME} = "otp-gitops-services" ]]; then
      echo "Repository ${GIT_GITOPS_SERVICES_NAME} not found, creating from template and cloning"
      gh repo create ${GIT_ORG}/otp-gitops-services --public --template https://github.com/one-touch-provisioning/otp-gitops-services
      gh repo clone ${GIT_ORG}/otp-gitops-services
      if [ ! -z ${NEW_FOLDERS} ]; then
        mv otp-gitops-services ${LOCAL_FOLDER_2}
      fi
    elif [[ ! -d ${LOCAL_FOLDER_2} ]]; then
      echo "Repository ${GIT_GITOPS_SERVICES_NAME} found but not cloned... cloning repository"
      gh repo clone ${GIT_ORG}/otp-gitops-services ${LOCAL_FOLDER_2}
    else
      echo "Repository ${GIT_GITOPS_SERVICES_NAME} exists and already cloned... nothing to do"
    fi
    cd ${LOCAL_FOLDER_2}
    git checkout ${GIT_GITOPS_SERVICES_BRANCH} || git checkout --track origin/${GIT_GITOPS_SERVICES_BRANCH}
    cd ..

    # OTP GITOPS POLICIES REPO
    GHREPONAME=$(gh api /repos/${GIT_ORG}/otp-gitops-policies -q .name || true)
    if [[ ! ${GHREPONAME} = "otp-gitops-policies" ]]; then
      echo "Repository ${GIT_GITOPS_POLICIES_NAME} not found, creating from template and cloning"
      gh repo create ${GIT_ORG}/otp-gitops-policies --public --template https://github.com/one-touch-provisioning/otp-gitops-policies
      gh repo clone ${GIT_ORG}/otp-gitops-policies
      if [ ! -z ${NEW_FOLDERS} ]; then
        mv otp-gitops-policies ${LOCAL_FOLDER_3}
      fi
    elif [[ ! -d ${LOCAL_FOLDER_3} ]]; then
      echo "Repository ${GIT_GITOPS_POLICIES_NAME} found but not cloned... cloning repository"
      gh repo clone ${GIT_ORG}/otp-gitops-policies ${LOCAL_FOLDER_3}
    else
      echo "Repository ${GIT_GITOPS_POLICIES_NAME} exists and already cloned... nothing to do"
    fi
    cd ${LOCAL_FOLDER_3}
    git checkout ${GIT_GITOPS_POLICIES_BRANCH} || git checkout --track origin/${GIT_GITOPS_POLICIES_BRANCH}
    cd ..

    # OTP GITOPS CLUSTERS REPO
    GHREPONAME=$(gh api /repos/${GIT_ORG}/otp-gitops-clusters -q .name || true)
    if [[ ! ${GHREPONAME} = "otp-gitops-clusters" ]]; then
      echo "Repository ${GIT_GITOPS_CLUSTERS_NAME} not found, creating from template and cloning"
      gh repo create ${GIT_ORG}/otp-gitops-clusters --public --template https://github.com/one-touch-provisioning/otp-gitops-clusters
      gh repo clone ${GIT_ORG}/otp-gitops-clusters
      if [ ! -z ${NEW_FOLDERS} ]; then
        mv otp-gitops-clusters ${LOCAL_FOLDER_4}
      fi
    elif [[ ! -d ${LOCAL_FOLDER_4} ]]; then
      echo "Repository ${GIT_GITOPS_CLUSTERS_NAME} found but not cloned... cloning repository"
      gh repo clone ${GIT_ORG}/otp-gitops-clusters ${LOCAL_FOLDER_4}
    else
      echo "Repository ${GIT_GITOPS_CLUSTERS_NAME} exists and already cloned... nothing to do"
    fi
    cd ${LOCAL_FOLDER_4}
    git checkout ${GIT_GITOPS_CLUSTERS_BRANCH} || git checkout --track origin/${GIT_GITOPS_CLUSTERS_BRANCH}
    cd ..

    # OTP GITOPS APPS REPO
    GHREPONAME=$(gh api /repos/${GIT_ORG}/otp-gitops-apps -q .name || true)
    if [[ ! ${GHREPONAME} = "otp-gitops-apps" ]]; then
      echo "Repository ${GIT_GITOPS_APPS_NAME} not found, creating from template and cloning"
      gh repo create ${GIT_ORG}/otp-gitops-apps --public --template https://github.com/one-touch-provisioning/otp-gitops-apps
      gh repo clone ${GIT_ORG}/otp-gitops-apps
      if [ ! -z ${NEW_FOLDERS} ]; then
        mv otp-gitops-apps ${LOCAL_FOLDER_5}
      fi
    elif [[ ! -d ${LOCAL_FOLDER_5} ]]; then
      echo "Repository ${GIT_GITOPS_APPS_NAME} found but not cloned... cloning repository"
      gh repo clone ${GIT_ORG}/otp-gitops-apps ${LOCAL_FOLDER_5}
    else
      echo "Repository ${GIT_GITOPS_APPS_NAME} exists and already cloned... nothing to do"
    fi
    cd ${LOCAL_FOLDER_5}
    git checkout ${GIT_GITOPS_APPS_BRANCH} || git checkout --track origin/${GIT_GITOPS_APPS_BRANCH}
    cd ..

    popd

}

# main

create_repos

exit 0