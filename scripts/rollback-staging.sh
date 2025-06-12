#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Script: rollback-staging.sh
# Purpose: Revert the last promotion to staging by reverting the Git commit
# Usage: ./rollback-staging.sh
# -----------------------------------------------------------------------------

# Confirm before proceeding
read -p "Are you sure you want to revert the last staging promotion? [y/N] " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Cancelled."
  exit 0
fi

# Identify the last commit that modified the staging values file
STAGING_FILE="overlays/staging/values/demo-api-values.yaml"
LAST_COMMIT=$(git log -n 1 --pretty=format:%H -- "$STAGING_FILE")

echo "Reverting commit: $LAST_COMMIT"
git revert "$LAST_COMMIT" --no-edit

echo "Commit reverted. Now pushing to main..."
git push origin main

echo "Rollback triggered. ArgoCD will sync the reverted version to staging automatically."
