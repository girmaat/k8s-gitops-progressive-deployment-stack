# Kustomize Overlays (Per Environment)

This directory contains environment-specific configuration (`overlays/`) used to apply deployment differences on top of reusable Helm charts.

Each subfolder (`dev/`, `staging/`, `prod/`) contains:
- `values/*.yaml`: Helm values specific to each service and environment
- `rendered.yaml`: Helm template output used by Kustomize
- `kustomization.yaml`: Defines how Kustomize composes the manifest

---

## Structure

```
overlays/
  dev/
    values/
      demo-api-values.yaml
      frontend-values.yaml
    kustomization.yaml
    rendered.yaml

  staging/
    values/
      demo-api-values.yaml
      frontend-values.yaml
    ...

  prod/
    ...
```

---

## What Goes Here?

- Environment-specific overrides: image tags, resource limits, probe timings, HPA, rollout steps.
- Kustomize applies these on top of rendered Helm templates before ArgoCD syncs them.

---

## Example Usage

```bash
# Build manifests for dev
kustomize build overlays/dev/

# Render Helm + Kustomize manually (optional testing)
helm template charts/services/demo-api -f overlays/staging/values/demo-api-values.yaml > overlays/staging/rendered.yaml
kustomize build overlays/staging/
```

---

## GitOps Workflow

Each environment is mapped to a separate ArgoCD `Application` (see `apps/*.yaml`).

Changes made here are:
- Version-controlled
- Promoted via PRs
- Synced automatically by ArgoCD

---

## Notes

- **Do not duplicate full YAMLs.** Only override via `values.yaml` or patches.
- **Always use Git commits/PRs** to modify overlays.
