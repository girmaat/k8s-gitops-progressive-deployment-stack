# 🌱 Kustomize Overlay: dev

Custom configuration for the `dev` environment.

---

## Table of Contents
- [Included Files](#included-files)
- [Customizations](#customizations)
- [Usage](#usage)

---

## Included Files

- `values/demo-api-values.yaml`: Helm values
- `kustomization.yaml`: Reference to base Helm output

## Customizations

- Lower resource limits
- Canary rollout without metric gating
- Debug image tags

## Usage

```bash
kustomize build overlays/dev/
```
