#!/bin/bash
set -euo pipefail

LOGFILE="./scripts/audit-gitops-report.log"
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"  # set externally
DRIFT_FOUND=0
VIOLATIONS_FOUND=0

echo "Starting GitOps Audit at $(date)"
echo "=====================================" | tee "$LOGFILE"

# -------------------------------
# 1. Run ArgoCD Drift Check
# -------------------------------
echo "Checking ArgoCD app drift..." | tee -a "$LOGFILE"
./scripts/verify-drift.sh --refresh >> "$LOGFILE"

if grep -q "Drift detected" "$LOGFILE"; then
  DRIFT_FOUND=1
fi

# -------------------------------
# 2. Gatekeeper Violations
# -------------------------------
echo "Checking Gatekeeper policy violations..." | tee -a "$LOGFILE"
kubectl get constrainttemplates --no-headers -o custom-columns=":metadata.name" | while read -r tmpl; do
  echo "Violations for policy: $tmpl" | tee -a "$LOGFILE"
  VIOLATIONS=$(kubectl get constraint --all-namespaces --selector="constrainttemplate=${tmpl}" -o yaml |
    yq '.items[] | select(.status.violations) | {name: .metadata.name, violations: .status.violations}' 2>/dev/null)

  if [[ -n "$VIOLATIONS" ]]; then
    VIOLATIONS_FOUND=1
    echo "$VIOLATIONS" | tee -a "$LOGFILE"
  fi
done

# -------------------------------
# 3. Send Slack Notification if Issues Found
# -------------------------------
if [[ "$DRIFT_FOUND" -eq 1 || "$VIOLATIONS_FOUND" -eq 1 ]]; then
  if [[ -n "$SLACK_WEBHOOK_URL" ]]; then
    echo "Alert: GitOps issues found, sending Slack notification."

    SNIPPET=$(tail -n 25 "$LOGFILE" | sed 's/"/\\"/g')
    curl -X POST -H 'Content-type: application/json' \
      --data @- "$SLACK_WEBHOOK_URL" <<EOF
{
  "attachments": [
    {
      "color": "#FF0000",
      "title": "GitOps Drift or Policy Violation Detected",
      "text": "The latest GitOps audit has detected one or more issues.",
      "fields": [
        {
          "title": "Drift",
          "value": "${DRIFT_FOUND}"
        },
        {
          "title": "Policy Violations",
          "value": "${VIOLATIONS_FOUND}"
        }
      ],
      "footer": "GitOps Audit Job",
      "ts": $(date +%s)
    },
    {
      "color": "#FFA500",
      "title": "Log Excerpt",
      "text": "```$SNIPPET```"
    }
  ]
}
EOF
  else
    echo "SLACK_WEBHOOK_URL not set. Skipping Slack alert."
  fi
else
  echo "No drift or violations detected. No alert sent."
fi

echo "GitOps audit complete."
