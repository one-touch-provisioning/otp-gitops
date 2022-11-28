# IBM Entitlement Key for IBM Cloud Paks 🔑

If you intend to deploy the Infrastructure Automation component of IBM Cloud Pak for Watson AIOps, then you will need add an `IBM Entitlement Key` to the OpenShift cluster. This is required to pull IBM Cloud Pak specific container images from the IBM Entitled Registry.

To get an entitlement key:

1. Log in to [MyIBM Container Software Library](https://myibm.ibm.com/products-services/containerlibrary) with an IBMid and password associated with the entitled software.  
2. Select the **View library** option to verify your entitlement(s).
3. Select the **Get entitlement key** to retrieve the key.

Create a **Secret** containing the entitlement key within the `ibm-infra-automation` namespace.

   ```sh
    oc new-project ibm-infra-automation || true
    oc create secret docker-registry ibm-entitlement-key -n ibm-infra-automation \
    --docker-username=cp \
    --docker-password="<entitlement_key>" \
    --docker-server=cp.icr.io \
    --docker-email=myemail@ibm.com
   ```

<p align="right">(<a href="https://github.com/one-touch-provisioning/otp-gitops/">back to main</a>)</p>