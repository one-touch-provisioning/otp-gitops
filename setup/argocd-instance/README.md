# Overview

Each file in the `resource-customizations` folder represents a set of resource customizations (health checks and diffings) grouped by products.

Example file in `example/example-instance.yaml` is created with:

`kubectl kustomize > example/example-instance.yaml`


# VSCode Snippets

To quickly create a new health check file in VSCode, 

1. Create a new code snippet ([docs](https://code.visualstudio.com/docs/editor/userdefinedsnippets#_create-your-own-snippets)) called `argocd-healthcheck-configmap.json`.
2. Add the following code into that snippet:

```
{
	"ArgoCD config map": {
		"scope": "yaml",
		"prefix": "argocm",
		"body": [
			"kind: ConfigMap",
			"apiVersion: v1",
			"metadata:",
			"  name: argocd-cm",
			"  namespace: openshift-gitops",
			"data:",
		]
	},
	"ArgoCD health resource": {
		"scope": "yaml",
		"prefix": "argorsh",
		"body": [
			"resource.customizations.health.${1:group}_${2:kind}: |",
			"  ${3:healthcheck_lua}",
		]
	},
	"ArgoCD ignoreDifferences resource": {
		"scope": "yaml",
		"prefix": "argorsi",
		"body": [
			"resource.customizations.ignoreDifferences.${1:group}_${2:kind}: |",
			"  ${3:diffing}",
		]
	}
}
```

3. In a new YAML file:

- Use `argocm` to create a new config map
- Use `argorsh` to add a health check resource
- Use `argorsi` to add an ignoreDifferences resource

# Health checks not transferred

These health checks/diffing are [maintained by ArgoCD](https://github.com/argoproj/argo-cd/tree/master/resource_customizations) and will not be transferred to the new configmap format.

- `bitnami.com/SealedSecret`
- `route.openshift.io/Route`
- `kubevirt.io/VirtualMachine`
- `kubevirt.io/VirtualMachineInstance`
- `cdi.kubevirt.io/DataVolume`
- `operators.coreos.com/Subscription`
