# Helm Chart: demo-api

Reusable Helm chart for the `demo-api` service with support for probes, HPA, resource controls, and Argo Rollouts integration.

---

## Table of Contents
- [Features](#features)
- [Required Values](#required-values)
- [Rendering Example](#rendering-example)
- [Templates](#templates)

---

##Features

- Supports readiness/liveness probes
- Optional HPA
- Rollouts-based deployment (via `.Values.strategy`)
- Resource/CPU/memory parameters
- Image + tag parameters

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
