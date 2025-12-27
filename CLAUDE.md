# OTP-GitOps: AI Assistant Guide

## Project Overview

**One Touch Provisioning (OTP)** is an opinionated GitOps pattern for seamless end-to-end provisioning of Red Hat OpenShift clusters, applications, governance, and policies across Public, Private, On-Premises, and Edge environments.

### Core Technologies
- **Red Hat Advanced Cluster Management (RHACM)**: Multi-cluster orchestration and lifecycle management
- **OpenShift GitOps (ArgoCD)**: Declarative continuous deployment
- **Kustomize**: Template-free Kubernetes configuration management
- **External Secrets Operator**: Secret management integration (Vault, IBM Secrets Manager)

### Key Capabilities
- Complete cluster provisioning and lifecycle management
- Comprehensive governance and policy enforcement
- Advanced observability for clusters and workloads
- Automated application deployment (including IBM Cloud Paks)
- Infrastructure as Code with full auditability

---

## Repository Architecture

OTP uses a **Polyrepo** structure with six specialized Git repositories:

1. **otp-gitops** (THIS REPOSITORY): RHACM Hub GitOps Repository
   - Contains ArgoCD Applications for infrastructure, services, policies, clusters, and applications
   - Manages bootstrap process and high-level orchestration
   - Controls deployment to both Hub and Spoke clusters

2. **otp-gitops-infra**: Infrastructure GitOps Repository
   - Cluster-wide infrastructure resources (namespaces, RBAC, machinesets, storage)
   - Shared across environments for consistency

3. **otp-gitops-services**: Services GitOps Repository
   - Operator subscriptions and custom resources
   - Third-party Helm charts
   - Shared services managed by platform teams

4. **otp-gitops-policies**: Policies GitOps Repository
   - Governance and security policies for Hub and Spoke clusters
   - Managed by GRC and Security teams

5. **otp-gitops-clusters**: Clusters GitOps Repository
   - OpenShift cluster definitions (ClusterDeployment, ClusterPool, ClusterClaim)
   - Managed by Platform Administrators

6. **otp-gitops-apps**: Apps GitOps Repository
   - Application deployments for Hub and Spoke clusters
   - Business applications and workloads

---

## Directory Structure

```
otp-gitops/
├── 0-bootstrap/              # Bootstrap configurations
│   ├── hub/                  # RHACM Hub cluster bootstrap
│   │   ├── 1-infra/         # Infrastructure layer
│   │   ├── 2-services/      # Services layer
│   │   ├── 3-policies/      # Policies layer
│   │   ├── 4-clusters/      # Clusters layer
│   │   ├── 5-apps/          # Applications layer
│   │   ├── bootstrap.yaml   # Main bootstrap Application
│   │   └── kustomization.yaml
│   └── spokeclusters/       # Spoke cluster configurations
│       ├── cicd/            # CICD environment spoke clusters
│       ├── dev/             # Development environment
│       ├── test/            # Test environment
│       └── prod/            # Production environment
├── doc/                      # Documentation
├── scripts/                  # Automation scripts
└── setup/                    # Initial setup configurations
    ├── argocd-operator/     # ArgoCD operator installation
    ├── argocd-instance/     # Custom ArgoCD instance config
    ├── external-secrets-operator/
    ├── external-secrets-instance/
    └── hashicorp-vault-chart/
```

### Key Directory Purposes

#### `0-bootstrap/hub/`
The heart of the Hub cluster GitOps configuration, organized in layers:

- **Layer 1 - Infrastructure** (`1-infra/`):
  - Namespaces, RBAC, storage configurations
  - Machine configurations, machinesets, machinepools
  - Infrastructure node configurations
  - **Pattern**: ArgoCD Applications point to `otp-gitops-infra` repository

- **Layer 2 - Services** (`2-services/`):
  - Operator installations (RHACM, Quay, ACS, AAP, etc.)
  - Operator instances and configurations
  - Organized as `operators/` and `instances/`
  - **Pattern**: ArgoCD Applications point to `otp-gitops-services` repository

- **Layer 3 - Policies** (`3-policies/`):
  - RHACM policies for governance and compliance
  - **Pattern**: ArgoCD Applications point to `otp-gitops-policies` repository

- **Layer 4 - Clusters** (`4-clusters/`):
  - ClusterDeployment, ClusterPool, and ClusterClaim definitions
  - Cluster lifecycle management
  - **Pattern**: ArgoCD Applications point to `otp-gitops-clusters` repository

- **Layer 5 - Applications** (`5-apps/`):
  - Business applications and workloads
  - **Pattern**: ArgoCD Applications point to `otp-gitops-apps` repository

#### `0-bootstrap/spokeclusters/`
Spoke cluster configurations organized by environment and project:
- Each project has its own bootstrap configuration
- Follows same layered approach: `1-infra/`, `2-services/`, `3-apps/`
- Applied to managed clusters via RHACM

#### `setup/`
Initial cluster setup resources:
- **argocd-operator/**: OpenShift GitOps operator subscription
- **argocd-instance/**: Custom ArgoCD instance with health checks and resource customizations
- **external-secrets-*/**: External Secrets Operator for secret management
- **hashicorp-vault-chart/**: Optional local Vault deployment

#### `scripts/`
Automation scripts for common operations:
- `bootstrap.sh`: Complete bootstrap automation
- `set-git-source.sh`: Update Git URLs and branches across all configurations
- `unset-git-source.sh`: Revert Git URL changes
- `create-repos.sh`: Fork and clone all OTP repositories
- `infra-mod.sh`: Configure storage and infrastructure nodes
- `patch-argocd-tls.sh`: IBM Cloud ROKS TLS configuration
- `git-add-commit-push.sh`: Git workflow automation

---

## Key Concepts and Patterns

### GitOps Layers and Sync Waves
OTP uses a **layered approach** with ArgoCD Sync Waves to control deployment order:

1. **Infrastructure** (Wave 0-100): Foundation components deployed first
2. **Services** (Wave 100-200): Operators and services deployed after infrastructure
3. **Policies** (Wave 200-300): Governance policies applied after services
4. **Clusters** (Wave 300-400): Managed clusters provisioned after policies
5. **Applications** (Wave 400-500): Workloads deployed last

**Sync Wave Annotation Example**:
```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "100"
```

### Kustomize Patterns

#### 1. **Base + Overlays Pattern** (in companion repos)
```
otp-gitops-services/
├── base/
│   └── operator/
└── overlays/
    ├── dev/
    ├── test/
    └── prod/
```

#### 2. **Patch Pattern** (in this repo)
Used extensively in `kustomization.yaml` files to inject Git URLs and branches:

```yaml
patches:
- target:
    group: argoproj.io
    kind: Application
    labelSelector: "gitops.tier.layer=infra"
  patch: |-
    - op: add
      path: /spec/source/repoURL
      value: https://github.com/ORG/otp-gitops-infra.git
    - op: add
      path: /spec/source/targetRevision
      value: ${GIT_GITOPS_BRANCH}
```

### ArgoCD Application Patterns

#### Standard Application Structure
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: <resource-name>
  namespace: openshift-gitops
  labels:
    gitops.tier.layer: <infra|services|policies|clusters|applications>
  annotations:
    argocd.argoproj.io/sync-wave: "<wave-number>"
spec:
  destination:
    namespace: <target-namespace>
    server: https://kubernetes.default.svc
  project: <project-name>
  source:
    path: <path-in-repo>
    repoURL: ${GIT_BASEURL}/${GIT_ORG}/<repo-name>
    targetRevision: ${GIT_BRANCH}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

#### App of Apps Pattern
The bootstrap follows the "App of Apps" pattern:
- `bootstrap.yaml` → creates layer Applications
- Layer Applications (1-infra, 2-services, etc.) → create resource Applications
- Resource Applications → deploy actual Kubernetes resources

### Variable Substitution
Git repository URLs use template variables replaced by scripts:
- `${GIT_BASEURL}`: GitHub base URL (default: https://github.com)
- `${GIT_ORG}`: GitHub organization name
- `${GIT_GITOPS_BRANCH}`: Branch for otp-gitops repo
- `${GIT_GITOPS_INFRA_BRANCH}`: Branch for otp-gitops-infra repo
- `${HELM_REPOURL}`: Helm chart repository URL

**Replacement performed by**: `scripts/set-git-source.sh`

---

## Development Workflow

### Initial Setup

1. **Fork Repositories**:
   ```bash
   GIT_ORG=<your-org> OUTPUT_DIR=<output-dir> ./scripts/create-repos.sh
   ```

2. **Update Git References**:
   ```bash
   GIT_ORG=<your-org> GIT_BRANCH=master ./scripts/set-git-source.sh
   ```

3. **Install OpenShift GitOps**:
   ```bash
   oc apply -k setup/argocd-operator
   while ! oc wait crd applications.argoproj.io --timeout=-1s --for=condition=Established 2>/dev/null; do sleep 30; done
   ```

4. **Create Custom ArgoCD Instance**:
   ```bash
   oc apply -k setup/argocd-instance
   while ! oc wait pod --timeout=-1s --for=condition=ContainersReady -l app.kubernetes.io/name=openshift-gitops-otp-server -n openshift-gitops >/dev/null; do sleep 30; done
   ```

5. **Bootstrap Hub Cluster**:
   ```bash
   oc apply -f 0-bootstrap/hub/bootstrap.yaml
   ```

### Making Changes

#### Adding Infrastructure Resources
1. Edit `0-bootstrap/hub/1-infra/kustomization.yaml`
2. Uncomment or add resource references
3. Commit and push to Git
4. ArgoCD automatically syncs changes

#### Adding Services (Operators/Instances)
1. Edit `0-bootstrap/hub/2-services/kustomization.yaml`
2. Add operator and/or instance ArgoCD Applications
3. Operators go in `argocd/operators/`
4. Instances go in `argocd/instances/`
5. Commit and push changes

#### Enabling Additional Layers
Edit `0-bootstrap/hub/kustomization.yaml` to enable clusters and apps layers:
```yaml
resources:
  - 1-infra/1-infra.yaml
  - 2-services/2-services.yaml
  - 3-policies/3-policies.yaml
  - 4-clusters/4-clusters.yaml  # Uncomment when ready
  - 5-apps/5-apps.yaml          # Uncomment when ready
```

### Testing Changes

1. **Dry Run with Kustomize**:
   ```bash
   oc kustomize 0-bootstrap/hub/1-infra/
   ```

2. **Validate ArgoCD Application**:
   ```bash
   oc get application -n openshift-gitops
   oc describe application <app-name> -n openshift-gitops
   ```

3. **Monitor Sync Status**:
   ```bash
   # Via CLI
   oc get applications -n openshift-gitops -w

   # Via UI
   oc get route -n openshift-gitops openshift-gitops-otp-server -o template --template='https://{{.spec.host}}'
   ```

### Troubleshooting

1. **Check ArgoCD Application Status**:
   ```bash
   oc get application <app-name> -n openshift-gitops -o yaml
   ```

2. **View ArgoCD Logs**:
   ```bash
   oc logs -n openshift-gitops -l app.kubernetes.io/name=openshift-gitops-otp-server
   ```

3. **Check Sync Waves**:
   ```bash
   oc get applications -n openshift-gitops -o custom-columns=NAME:.metadata.name,WAVE:.metadata.annotations.argocd\.argoproj\.io/sync-wave
   ```

4. **Common Issues**:
   - **Application OutOfSync**: Check if Git changes were committed
   - **Resource Creation Failed**: Verify CRDs are installed (sync wave order)
   - **Namespace Not Found**: Ensure infrastructure layer created namespace first

---

## Naming Conventions

### Files
- **ArgoCD Applications**: `<resource-name>.yaml` (e.g., `openshift-acm.yaml`)
- **Kustomization files**: Always `kustomization.yaml`
- **Layer aggregators**: `<layer>-<name>.yaml` (e.g., `1-infra.yaml`, `2-services.yaml`)

### ArgoCD Applications
- **Operators**: `<product>-operator` (e.g., `openshift-acm`)
- **Instances**: `<product>-instance` (e.g., `openshift-acm-instance`)
- **Namespaces**: `namespace-<name>` (e.g., `namespace-openshift-acm`)

### Namespaces
- **Pattern**: Descriptive, hyphenated lowercase
- **Examples**:
  - `openshift-acm`
  - `openshift-gitops`
  - `rhacm-credentials`
  - `rhacm-policies`

### Labels
ArgoCD Applications use standard labels:
- `gitops.tier.layer`: Layer identifier (`infra`, `services`, `policies`, `clusters`, `applications`)
- `gitops.tier.source`: Source type (`git`, `helm`)

---

## Common Tasks

### Adding a New Namespace

1. Create namespace definition in `otp-gitops-infra` repository
2. Add ArgoCD Application in `0-bootstrap/hub/1-infra/argocd/namespaces/`:
   ```yaml
   apiVersion: argoproj.io/v1alpha1
   kind: Application
   metadata:
     name: namespace-<name>
     namespace: openshift-gitops
     labels:
       gitops.tier.layer: infra
     annotations:
       argocd.argoproj.io/sync-wave: "100"
   spec:
     destination:
       namespace: openshift-gitops
       server: https://kubernetes.default.svc
     project: infra
     source:
       path: namespace/<name>
       repoURL: ${GIT_BASEURL}/${GIT_ORG}/otp-gitops-infra.git
       targetRevision: ${GIT_GITOPS_INFRA_BRANCH}
     syncPolicy:
       automated:
         prune: true
         selfHeal: true
   ```
3. Add to `0-bootstrap/hub/1-infra/kustomization.yaml`:
   ```yaml
   resources:
     - argocd/namespaces/namespace-<name>.yaml
   ```

### Adding a New Operator

1. Create operator subscription in `otp-gitops-services` repository
2. Add ArgoCD Application in `0-bootstrap/hub/2-services/argocd/operators/`
3. Add to `0-bootstrap/hub/2-services/kustomization.yaml`
4. Typically add corresponding namespace in infrastructure layer first

### Adding a New Managed Cluster

1. Create cluster definition in `otp-gitops-clusters` repository
2. Add ArgoCD Application in `0-bootstrap/hub/4-clusters/argocd/clusters/`
3. Organize by environment: `prod/`, `dev/`, `test/`, `cicd/`
4. Add cloud provider credentials via External Secrets

### Configuring Spoke Cluster Bootstrap

1. Navigate to appropriate environment: `0-bootstrap/spokeclusters/<env>/<project>/`
2. Edit layer kustomization files:
   - `1-infra/kustomization.yaml`
   - `2-services/kustomization.yaml`
   - `3-apps/kustomization.yaml`
3. Create ApplicationSet or Application to deploy to spoke clusters

---

## Important Files Reference

### Bootstrap Files
- **`0-bootstrap/hub/bootstrap.yaml`**: Entry point for entire GitOps workflow
- **`0-bootstrap/hub/kustomization.yaml`**: Controls which layers are enabled
- **`0-bootstrap/hub/*/kustomization.yaml`**: Layer-specific resource inclusion

### Configuration Files
- **`setup/argocd-instance/argocd-cm.yaml`**: ArgoCD ConfigMap with custom resource health checks
- **`setup/argocd-instance/argocd-instance.yaml`**: Custom ArgoCD instance definition
- **`setup/argocd-operator/subscription.yaml`**: OpenShift GitOps operator subscription

### Documentation
- **`README.md`**: User-facing installation and usage guide
- **`doc/capabilities.md`**: OTP capabilities overview
- **`doc/hubandspoke-concepts.md`**: RHACM architecture concepts
- **`doc/git-repo-context.md`**: Repository organization rationale
- **`doc/folder-orgs.md`**: Directory organization strategies

---

## Scripts Reference

### `scripts/set-git-source.sh`
**Purpose**: Replace template variables with actual Git URLs and branches

**Required Environment Variables**:
- `GIT_ORG`: GitHub organization name
- `GIT_BRANCH` (optional): Default branch (default: master)

**Usage**:
```bash
GIT_ORG=my-org GIT_BRANCH=main ./scripts/set-git-source.sh
```

**What it does**:
- Finds all YAML files in `0-bootstrap/hub/`
- Replaces `${GIT_BASEURL}/${GIT_ORG}/*` with actual URLs
- Replaces branch placeholders with actual branch names
- Commits and pushes changes

### `scripts/unset-git-source.sh`
**Purpose**: Revert Git URL replacements back to template variables

### `scripts/bootstrap.sh`
**Purpose**: Complete automated bootstrap of OTP

**What it does**:
1. Forks/clones all OTP repositories
2. Updates pull secrets (if IBM_ENTITLEMENT_KEY provided)
3. Initializes sealed secrets (if SEALED_SECRET_KEY_FILE provided)
4. Installs OpenShift GitOps operator
5. Creates custom ArgoCD instance
6. Configures ArgoCD git override
7. Deploys bootstrap ArgoCD Application

### `scripts/infra-mod.sh`
**Purpose**: Configure infrastructure nodes and storage

**Use Cases**:
- Deploy additional nodes for OpenShift Data Foundation
- Configure infrastructure nodes for RHACM, Quay, etc.
- Not required for IBM Cloud ROKS

### `scripts/create-repos.sh`
**Purpose**: Fork and clone all OTP repositories

**Required Environment Variables**:
- `GIT_ORG`: Target GitHub organization
- `OUTPUT_DIR`: Local directory for cloned repos

---

## Best Practices for AI Assistants

### When Making Changes

1. **Always Read Before Editing**:
   - Use `Read` tool to examine existing files before modifications
   - Understand current structure and patterns
   - Maintain consistency with existing conventions

2. **Preserve Patterns**:
   - Follow existing naming conventions
   - Maintain label and annotation patterns
   - Keep sync wave ordering consistent within layers

3. **Layer Awareness**:
   - Respect layer dependencies (infra → services → policies → clusters → apps)
   - Use appropriate sync waves for proper ordering
   - Infrastructure components (namespaces, RBAC) go in Layer 1
   - Operators and instances go in Layer 2

4. **Kustomize Best Practices**:
   - Don't modify generated files directly
   - Use overlays for environment-specific changes
   - Leverage patches for configuration injection
   - Validate with `oc kustomize` before committing

5. **Git Workflow**:
   - Always commit changes before ArgoCD will see them
   - Use descriptive commit messages
   - Reference issue numbers when applicable
   - Push to correct branch specified in ArgoCD Applications

6. **Template Variables**:
   - Never hardcode Git URLs - use template variables
   - Run `set-git-source.sh` after adding new ArgoCD Applications
   - Understand that variables are replaced at setup time, not runtime

### When Troubleshooting

1. **Check Layer Order**:
   - Verify sync waves are correct
   - Ensure dependencies are met (CRDs before CRs)
   - Infrastructure must complete before services

2. **Validate ArgoCD Applications**:
   - Check Application status and health
   - Review sync errors in ArgoCD UI or via `oc describe`
   - Verify Git repository is accessible and branch exists

3. **Common Pitfalls**:
   - Namespace not created before resources deployed to it
   - CRD not installed before Custom Resource created
   - Operator not ready before instance created
   - Git changes not committed/pushed

4. **Resource Ordering**:
   - Namespaces: Wave 100
   - RBAC: Wave 110
   - Operators: Wave 200
   - Operator Instances: Wave 300+
   - Applications: Wave 400+

### When Adding New Components

1. **Research First**:
   - Check if similar component already exists
   - Review existing patterns in the same layer
   - Understand dependencies and prerequisites

2. **Plan Dependencies**:
   - Identify required namespaces
   - Determine if CRDs are needed
   - Plan sync wave ordering

3. **Follow Established Patterns**:
   - Use existing Applications as templates
   - Maintain consistent label usage
   - Follow directory organization conventions

4. **Test Incrementally**:
   - Test each layer independently
   - Verify Application sync success before proceeding
   - Use ArgoCD UI to monitor deployment

### Understanding This vs. Companion Repos

**This Repository (otp-gitops)**:
- Contains **ArgoCD Application definitions**
- Acts as the **orchestrator**
- Points to actual resources in companion repos
- **Don't put actual Kubernetes resources here** (except bootstrap)

**Companion Repositories**:
- **otp-gitops-infra**: Actual namespace YAML, RBAC YAML, storage configs
- **otp-gitops-services**: Actual operator subscriptions, instance CRs
- **otp-gitops-policies**: Actual RHACM policy definitions
- **otp-gitops-clusters**: Actual ClusterDeployment/ClusterPool/ClusterClaim YAML
- **otp-gitops-apps**: Actual application deployments

**Rule of Thumb**:
- If it's an ArgoCD Application → `otp-gitops` repo
- If it's actual Kubernetes resource → appropriate companion repo

---

## Architecture Diagrams

### GitOps Flow
```
0-bootstrap/hub/bootstrap.yaml (Root Application)
    │
    ├─→ 1-infra.yaml (Infrastructure Layer)
    │       ├─→ namespace-* (Applications)
    │       ├─→ rbac-* (Applications)
    │       └─→ storage-* (Applications)
    │
    ├─→ 2-services.yaml (Services Layer)
    │       ├─→ *-operator (Applications)
    │       └─→ *-instance (Applications)
    │
    ├─→ 3-policies.yaml (Policies Layer)
    │       └─→ policy-* (Applications)
    │
    ├─→ 4-clusters.yaml (Clusters Layer)
    │       ├─→ ClusterPools
    │       ├─→ ClusterClaims
    │       └─→ ClusterDeployments
    │
    └─→ 5-apps.yaml (Applications Layer)
            └─→ app-* (Applications)
```

### Repository Relationships
```
otp-gitops (Orchestration)
    ├─→ points to → otp-gitops-infra (Resources)
    ├─→ points to → otp-gitops-services (Resources)
    ├─→ points to → otp-gitops-policies (Resources)
    ├─→ points to → otp-gitops-clusters (Resources)
    └─→ points to → otp-gitops-apps (Resources)
```

---

## Quick Reference

### Essential Commands

```bash
# Get ArgoCD URL
oc get route -n openshift-gitops openshift-gitops-otp-server -o template --template='https://{{.spec.host}}'

# Get ArgoCD admin password
oc extract secrets/openshift-gitops-otp-cluster --keys=admin.password -n openshift-gitops --to=-

# List all ArgoCD Applications
oc get applications -n openshift-gitops

# View Application details
oc describe application <app-name> -n openshift-gitops

# Manually sync an Application
oc patch application <app-name> -n openshift-gitops --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'

# View kustomize output
oc kustomize 0-bootstrap/hub/1-infra/

# Check sync waves
oc get applications -n openshift-gitops -o custom-columns=NAME:.metadata.name,WAVE:.metadata.annotations.argocd\.argoproj\.io/sync-wave
```

### File Locations Cheat Sheet

| What                    | Location                                          |
|------------------------|---------------------------------------------------|
| Main bootstrap         | `0-bootstrap/hub/bootstrap.yaml`                  |
| Layer enablement       | `0-bootstrap/hub/kustomization.yaml`              |
| Infrastructure config  | `0-bootstrap/hub/1-infra/kustomization.yaml`      |
| Services config        | `0-bootstrap/hub/2-services/kustomization.yaml`   |
| Policies config        | `0-bootstrap/hub/3-policies/kustomization.yaml`   |
| Clusters config        | `0-bootstrap/hub/4-clusters/kustomization.yaml`   |
| Apps config            | `0-bootstrap/hub/5-apps/kustomization.yaml`       |
| Spoke configs          | `0-bootstrap/spokeclusters/<env>/<project>/`      |
| ArgoCD instance        | `setup/argocd-instance/argocd-instance.yaml`      |
| ArgoCD health checks   | `setup/argocd-instance/argocd-cm.yaml`            |
| Scripts                | `scripts/`                                        |

---

## Additional Resources

### Internal Documentation
- README.md - Main project documentation
- doc/capabilities.md - Detailed OTP capabilities
- doc/hubandspoke-concepts.md - RHACM concepts
- doc/git-repo-context.md - Repository strategy rationale
- doc/folder-orgs.md - Organization patterns

### External References
- [OpenShift GitOps Documentation](https://docs.openshift.com/container-platform/latest/cicd/gitops/understanding-openshift-gitops.html)
- [ArgoCD Documentation](https://argoproj.github.io/argo-cd/)
- [RHACM Documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/)
- [Kustomize Documentation](https://kustomize.io/)
- [Cloud Native Toolkit GitOps Reference](https://cloudnativetoolkit.dev/adopting/use-cases/gitops/)

---

## Version Information

- **Minimum OpenShift Version**: 4.10+
- **Minimum OC CLI Version**: 4.10+
- **ArgoCD**: Managed via OpenShift GitOps operator
- **RHACM**: Version managed via operator subscription in services layer

---

**Last Updated**: 2025-12-27
**Repository**: https://github.com/one-touch-provisioning/otp-gitops
**Maintainers**: See README.md for team contact information
