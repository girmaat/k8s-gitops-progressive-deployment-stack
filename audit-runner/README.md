# 🕵️ GitOps Audit Runner

Containerized runner for GitOps auditing used in a CronJob.

---

## Table of Contents
- [What's Included](#whats-included)
- [Dockerfile](#dockerfile)
- [Usage](#usage)

---

## What's Included

- `audit-gitops.sh`, `verify-drift.sh`
- Dockerfile with bash, argocd CLI, kubectl, yq, curl

## Dockerfile

Alpine-based image that runs audit on entrypoint.  
Used by `monitoring/gitops-audit-cronjob.yaml`.

## Usage

```bash
docker build -t ghcr.io/org/gitops-audit:latest .
```
