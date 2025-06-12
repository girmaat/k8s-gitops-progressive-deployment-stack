# Automation Scripts

Scripts for GitOps workflows and cluster auditing.

---

## Table of Contents
- [Promotion](#promotion)
- [Drift Detection](#drift-detection)
- [Audit & Policy Scan](#audit--policy-scan)

---

### Promote a Service

```bash
# Promote demo-api from staging → prod
./scripts/promote.sh demo-api

# Promote frontend from dev → staging
./scripts/promote.sh frontend dev staging

##  Drift Detection

- `verify-drift.sh`: Runs `argocd app diff` for drift reporting

## Audit & Policy Scan

- `audit-gitops.sh`: Combines drift check and Gatekeeper scan, sends Slack alert

# scripts/

Automation scripts to support GitOps workflows.

- `promote-image-to-prod.sh` — safely promotes staging → prod
- `verify-drift.sh` — drift detection against ArgoCD
- `audit-gitops.sh` — full audit with Slack alert