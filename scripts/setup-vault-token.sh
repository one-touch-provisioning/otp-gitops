#!/bin/bash
if [[ -z ${VAULT_TOKEN} ]]; then
  echo "env var VAULT_TOKEN NOT provided"
  exit 1
fi

oc create ns external-secrets

vaultTokenEncoded=$(echo ${VAULT_TOKEN} | base64)

echo "Create the secret for vaults"
read -r -d '' vaultTokenSecret <<- EOM
kind: Secret
apiVersion: v1
metadata:
  name: vault-token
  namespace: external-secrets
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: >
      {"apiVersion":"v1","data":{"token":"cy41djJrY3psbzR1akpTNGVvVllDUWFkclY="},"kind":"Secret","metadata":{"annotations":{},"name":"vault-token","namespace":"external-secrets"}}
data:
  token: ${vaultTokenEncoded}
type: Opaque
EOM

oc create -f <(echo "${vaultTokenSecret}")
