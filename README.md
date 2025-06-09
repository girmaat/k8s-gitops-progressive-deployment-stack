# k8s-gitops-progressive-deployment-stack

> A full-stack GitOps delivery pipeline with Helm, Kustomize, ArgoCD, Argo Rollouts, Gatekeeper, and Slack-integrated audit workflows.

---

## Table of Contents
- [Project Structure](#-project-structure)
- [Environments](#-environments)
- [Getting Started](#️-getting-started)
- [Drift Detection & Auditing](#-drift-detection--auditing)
- [Policies Enforced (Gatekeeper)](#-policies-enforced-gatekeeper)
- [Ownership](#-ownership)

---

## Project Structure

```plaintext
.
├── apps/                      # ArgoCD app manifests
├── charts/                   # Helm base charts
├── overlays/                 # Env-specific Kustomize overlays
├── argo-config/              # ArgoCD project/image updater config
├── rollout-strategies/      # Canary rollout definitions
├── policies/                # Gatekeeper templates + constraints
├── monitoring/              # Grafana dashboards, alerts
├── scripts/                 # Promotion, audit, drift detection
├── audit-runner/            # Dockerized CronJob image
└── project-metadata.yaml    # Metadata and ownership
```

## Environments

| Env      | Namespace | ArgoCD Sync | Rollout Strategy        |
|----------|-----------|-------------|--------------------------|
| dev      | `dev`     | Auto      | Basic canary             |
| staging  | `staging` | Auto      | Canary with metrics      |
| prod     | `prod`    | Auto      | Canary + analysis + pause|

## Getting Started

```bash
# Deploy dev app via ArgoCD
kubectl apply -f apps/dev-demo-api.yaml

# Render Helm with dev values
helm template charts/services/demo-api -f overlays/dev/values/demo-api-values.yaml
```

## Drift Detection & Auditing

- `scripts/verify-drift.sh`: Detects ArgoCD drift
- `scripts/audit-gitops.sh`: Runs drift + Gatekeeper checks + Slack alert
- `audit-runner/`: Docker container & CronJob for automation

## Policies Enforced (Gatekeeper)

- Block `image: latest`
- Require `team` label
- Extendable with new rules

## Ownership

Defined in `project-metadata.yaml`.
