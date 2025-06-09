# Monitoring

Dashboards, alerts, and observability configs for Argo Rollouts, HPA, and drift detection.

---

## Table of Contents
- [Grafana Dashboards](#grafana-dashboards)
- [Alerting](#alerting)
- [CronJobs](#cronjobs)

---

## Grafana Dashboards

- `demo-api-rollout.json`: Canary rollout visualization
- `namespace-rollout-resource-usage.json`: Rollout-specific resource usage

## Alerting

- Slack alerts for drift and policy violations are integrated with `audit-gitops.sh`.

## CronJobs

- `gitops-audit-cronjob.yaml`: Triggers `audit-gitops.sh` container to scan hourly.
