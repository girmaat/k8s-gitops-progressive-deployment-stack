# 🧭 Onboarding a New Service into the GitOps Repository

This guide walks you through safely adding a new service to the GitOps repo using the shared Helm chart in `charts/base-chart/`.

All services (e.g., demo-api, frontend, inventory) share the same rollout-enabled chart and follow the same promotion and overlay structure.

---

## Pre-requisites

- You have push access to this Git repository
- Your service has a container image published (e.g., in GHCR or ECR)
- You understand Git-based promotion and overlays

---

## Onboarding Steps (Quick Checklist)

### 1. Create Per-Environment Values Files

Add these:

```bash
overlays/dev/values/<service>-values.yaml
overlays/staging/values/<service>-values.yaml
overlays/prod/values/<service>-values.yaml
```

Example (canary strategy):

```yaml
image:
  repository: ghcr.io/your-org/<service>
  tag: v1.0.0

service:
  port: 8080

strategy:
  type: canary
  canary:
    steps:
      - setWeight: 25
      - pause: { duration: 30s }
      - setWeight: 100
```

---

### 2. Add ArgoCD App Files

Create:

```bash
apps/<service>/dev.yaml
apps/<service>/staging.yaml
apps/<service>/prod.yaml
```

Each should point to the correct overlay path:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: <service>-dev
spec:
  source:
    repoURL: https://github.com/your-org/your-repo
    path: overlays/dev
  destination:
    server: https://kubernetes.default.svc
    namespace: dev
  project: default
  syncPolicy:
    automated: {}
```

---

### 3. Regenerate Rendered Manifests

Run the render script:

```bash
./scripts/render-all-services.sh
```

It automatically loops through all `*-values.yaml` files and updates:

```
overlays/dev/rendered.yaml
overlays/staging/rendered.yaml
overlays/prod/rendered.yaml
```

---

### 4. ArgoCD Sync (App-of-Apps)

If `app-of-apps.yaml` is already watching `apps/**`, no changes are needed.

ArgoCD will detect new apps automatically.

---

### 5. Confirm Sync in ArgoCD UI

- Open ArgoCD
- Look for `<service>-dev`, `-staging`, `-prod`
- Verify:
  - `kind: Rollout` exists
  - Canary/BlueGreen works
  - Probes, image tags, and steps render correctly

---

## Optional Governance

### CODEOWNERS

Add rules for required approvals:

```text
overlays/prod/values/<service>-values.yaml @devopsadmin
charts/services/<service>/* @<developer>
```

### project-metadata.yaml

```yaml
<service-name>:
  owner: dev1
  environments: [dev, staging, prod]
```

---

## Notes

- All services use the shared chart: `charts/base-chart/`
- Never duplicate templates or Chart.yaml in `charts/services/<service>/`
- Only Helm values belong in `charts/services/<service>/values.yaml` (optional)
- Use `promote.sh` and `rollback-prod.sh` for Git-based delivery

---

This document is maintained by the DevOps team. Please PR improvements or reach out with questions.
