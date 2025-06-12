# Helm Chart: demo-api

Reusable Helm chart for the `demo-api` service with support for probes, HPA, resource controls, and Argo Rollouts integration.

## Features

- Supports **Rollout** and **Deployment** modes
- Canary and Blue-Green rollout strategies
- Health checks (probes), HPA, resource limits
- Works with GitOps overlays and ArgoCD
- Clean separation of chart logic vs. service configuration

## Required Values

```yaml
image:
  repository:
  tag:
  pullPolicy:
replicaCount:
readinessProbe:
livenessProbe:
resources:
strategy:
```

## Rendering Example

```bash
helm template ./charts/services/demo-api -f overlays/dev/values/demo-api-values.yaml
```

## Templates

- `deployment.yaml` or `rollout.yaml`
- `hpa.yaml`
- `service.yaml`
- `analysis-template.yaml`

## How to Use

### 1. Point Helm to this chart:

In `scripts/render-all-services.sh`:
```bash
CHART_PATH="charts/base-chart"

### 2. Configure per-service rollout values:
In overlays/dev/values/demo-api-values.yaml:
strategy:
  type: canary
  canary:
    steps:
      - setWeight: 25
      - pause: { duration: 30s }
      - setWeight: 100

Or in overlays/prod/values/frontend-values.yaml:
strategy:
  type: blueGreen


### 3. Output generated manifests:
helm template demo-api charts/base-chart -f overlays/dev/values/demo-api-values.yaml
Or run:
./scripts/render-all-services.sh

### When to Modify This Chart
  - You may update this chart if:
  - You want to add new rollout features (e.g., experiment analysis)
  - You need to support additional container settings (e.g., sidecars)
  - You want to improve templates (labels, annotations, etc.)
  - Changes to this chart affect all services.

### What Not to Do
  - Do not duplicate this chart into charts/services/<service>/templates/
  - Do not modify chart logic in a service-specific way