#!/bin/bash

# -----------------------------------------------------------------------------
# GitOps Drift Detection Script for ArgoCD
# -----------------------------------------------------------------------------
# - Compares Git state vs live cluster for each ArgoCD-managed app
# - Outputs structured logs
# - Detects drift without making changes
# - Optional: --refresh to sync ArgoCD's cache before checking
# -----------------------------------------------------------------------------

set -euo pipefail

APP_PREFIX="demo-api"                    # Filter by app prefix (your Helm chart/app name)
ENVIRONMENTS=("dev" "staging" "prod")   # Environments to check
LOGFILE="./scripts/drift-report.log"    # Log output file
REFRESH="false"                         # Refresh ArgoCD app cache

# Handle optional --refresh flag
if [[ "${1:-}" == "--refresh" ]]; then
  REFRESH="true"
fi

# Start log entry
echo "" >> "$LOGFILE"
echo "Drift check run at $(date)" >> "$LOGFILE"
echo "------------------------------------------" >> "$LOGFILE"

DRIFT_FOUND=0

for ENV in "${ENVIRONMENTS[@]}"; do
  APP_NAME="${APP_PREFIX}-${ENV}"

  echo "Checking app: $APP_NAME"
  echo "Checking app: $APP_NAME" >> "$LOGFILE"

  if [[ "$REFRESH" == "true" ]]; then
    echo "Refreshing app state from cluster..."
    argocd app refresh "$APP_NAME" --hard >> "$LOGFILE" 2>&1
  fi

  echo "Running ArgoCD diff..."
  if ! argocd app diff "$APP_NAME" >> "$LOGFILE" 2>&1; then
    echo "Drift detected in [$APP_NAME]"
    echo "Drift detected in [$APP_NAME]" >> "$LOGFILE"
    DRIFT_FOUND=1
  else
    echo "No drift detected in [$APP_NAME]"
    echo "No drift detected in [$APP_NAME]" >> "$LOGFILE"
  fi

  echo "" >> "$LOGFILE"
done

echo "Drift check complete."

if [[ "$DRIFT_FOUND" -eq 1 ]]; then
  echo "ALERT: Drift detected in one or more applications!"
  echo "See $LOGFILE for full diff logs"
else
  echo "All applications match Git (no drift)"
fi
