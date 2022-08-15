#!/bin/bash

argocd_url="$(oc get route router-default -n openshift-ingress -o jsonpath='{.spec.host}')"
pattern="router-default\.(.+)\..+\.containers\.appdomain\.cloud"
[[ "$argocd_url" =~ $pattern ]]
ingress_secret_name="${BASH_REMATCH[1]}"

oc get secret $ingress_secret_name -n openshift-ingress -o jsonpath='{.data.tls\.crt}' | base64 -d > $(pwd)/tls.crt
oc get secret $ingress_secret_name -n openshift-ingress -o jsonpath='{.data.tls\.key}' | base64 -d > $(pwd)/tls.key

oc create -n openshift-gitops secret tls argocd-server-tls \
  --cert=$(pwd)/tls.crt \
  --key=$(pwd)/tls.key

# Clean up keys
rm $(pwd)/tls.crt
rm $(pwd)/tls.key