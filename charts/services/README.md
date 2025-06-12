# Helm Service Charts

This folder contains Helm charts for microservices deployed via GitOps. Each chart is structured for reusability and environment-specific configuration via overlays and values files.

---

## Structure

```
charts/
  services/
    demo-api/        # Helm chart for demo-api
    frontend/        # Helm chart for frontend
```

Each service subfolder typically includes:
- `Chart.yaml`: Metadata (name, version, appVersion)
- `values.yaml`: Default, base-level config (overridden by environment overlays)
- `templates/`: Kubernetes YAML templates using Helm functions
- `_helpers.tpl`: Shared naming/labeling conventions

---

## Features Supported

| Feature      | Description |
|--------------|-------------|
| Probes       | Readiness and liveness probes are configurable via values |
| HPA          | Enable/disable HorizontalPodAutoscaler with custom thresholds |
| Rollouts     | Canary rollout logic using `kind: Rollout` and strategy steps |
| Resource Limits | Define CPU/memory requests and limits per environment |
| Strategy     | Support both RollingUpdate and Argo Rollouts via `.Values.strategy` |

---

## Rendering Example

Render manifests for specific environments:
```bash
# demo-api for dev
helm template ./charts/services/demo-api \
  -f overlays/dev/values/demo-api-values.yaml

# frontend for staging
helm template ./charts/services/demo-api \
  -f overlays/staging/values/frontend-values.yaml
```

> Note: All services reuse the same Helm chart (`demo-api/`) via value overrides.

---

## Best Practices

- Keep chart logic generic and reusable across services.
- Use `values.yaml` for defaults; override per environment in `overlays/`.
- Parameterize all input (image, probes, HPA, strategy) — no hardcoding.

