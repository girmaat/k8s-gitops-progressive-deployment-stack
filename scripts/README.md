# Automation Scripts

Scripts for GitOps workflows and cluster auditing.

---

## Table of Contents
- [Promotion](#promotion)
- [Drift Detection](#drift-detection)
- [Audit & Policy Scan](#audit--policy-scan)

---

## Promotion

- `promote-to-prod.sh`: Promote image from staging to prod

##  Drift Detection

- `verify-drift.sh`: Runs `argocd app diff` for drift reporting

## Audit & Policy Scan

- `audit-gitops.sh`: Combines drift check and Gatekeeper scan, sends Slack alert
