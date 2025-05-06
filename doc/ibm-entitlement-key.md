# IBM Entitlement Key for IBM Cloud Paks 🔑

## Overview
To deploy the Infrastructure Automation component of IBM Cloud Pak for Watson AIOps, you'll need to configure an IBM Entitlement Key in your OpenShift cluster. This key enables secure access to IBM Cloud Pak container images from the IBM Entitled Registry.

## Prerequisites
- An IBMid with access to IBM Cloud Pak for Watson AIOps
- Access to an OpenShift cluster
- OpenShift CLI (`oc`) installed and configured

## Getting Your Entitlement Key

1. Visit the [MyIBM Container Software Library](https://myibm.ibm.com/products-services/containerlibrary)
2. Sign in with your IBMid and password
3. Click **View library** to confirm your entitlements
4. Select **Get entitlement key** to obtain your unique key

## Configuring the Entitlement Key

Create a Kubernetes Secret in the `ibm-infra-automation` namespace using the following command:

```sh
# Create the namespace if it doesn't exist
oc new-project ibm-infra-automation || true

# Create the secret with your entitlement key
oc create secret docker-registry ibm-entitlement-key \
    --namespace ibm-infra-automation \
    --docker-username=cp \
    --docker-password="<your_entitlement_key>" \
    --docker-server=cp.icr.io \
    --docker-email=your.email@example.com
```

> **Note**: Replace `<your_entitlement_key>` with your actual entitlement key and update the email address to match your IBMid email.

## Verification
To verify the secret was created successfully, run:
```sh
oc get secret ibm-entitlement-key -n ibm-infra-automation
```

## Next Steps
Once you've configured the entitlement key, you can proceed with deploying the Infrastructure Automation component of IBM Cloud Pak for Watson AIOps.

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>