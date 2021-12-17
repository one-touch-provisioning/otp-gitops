#!/usr/bin/env bash

set -eo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ -n "${DEBUG:-}" ]] && set -x


if [ -z ${GIT_ORG} ]; then echo "Please set GIT_ORG when running script, optional GIT_BASEURL and GIT_REPO to formed the git url GIT_BASEURL/GIT_ORG/*"; exit 1; fi

set -u

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
HELM_REPOURL=${HELM_REPOURL:-https://charts.cloudnativetoolkit.dev}

echo "Reseting variables to its template default"

find ${SCRIPTDIR}/../0-bootstrap -name '*.yaml' -print0 |
  while IFS= read -r -d '' File; do
    if grep -q "kind: Application\|kind: AppProject" "$File"; then
      #echo "$File"
      sed -i'.bak' -e "s#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS}#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS}#" $File
      sed -i'.bak' -e "s#${GIT_GITOPS_BRANCH}#\${GIT_GITOPS_BRANCH}#" $File
      sed -i'.bak' -e "s#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_INFRA}#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_INFRA}#" $File
      sed -i'.bak' -e "s#${GIT_GITOPS_INFRA_BRANCH}#\${GIT_GITOPS_INFRA_BRANCH}#" $File
      sed -i'.bak' -e "s#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_SERVICES}#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_SERVICES}#" $File
      sed -i'.bak' -e "s#${GIT_GITOPS_SERVICES_BRANCH}#\${GIT_GITOPS_SERVICES_BRANCH}#" $File
      sed -i'.bak' -e "s#${GIT_BASEURL}/${GIT_ORG}/${GIT_GITOPS_APPLICATIONS}#\${GIT_BASEURL}/\${GIT_ORG}/\${GIT_GITOPS_APPLICATIONS}#" $File
      sed -i'.bak' -e "s#${GIT_GITOPS_APPLICATIONS_BRANCH}#\${GIT_GITOPS_APPLICATIONS_BRANCH}#" $File
      sed -i'.bak' -e "s#${HELM_REPOURL}#\${HELM_REPOURL}#" $File
      rm "${File}.bak"
    fi
  done
echo "done replacing variables in kustomization.yaml files"
echo "git commit and push changes now"
