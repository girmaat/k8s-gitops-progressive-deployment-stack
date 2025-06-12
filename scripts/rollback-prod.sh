#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Script: rollback-prod.sh
# Purpose: Revert the last promotion to production by reverting the Git commit
# Usage: ./rollback-prod.sh
# -----------------------------------------------------------------------------

# Confirm before proceeding
read -p "Are you sure you want to revert the last production promotion? [y/N] " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Cancelled."
  exit 0
fi

# Identify the last commit that modified the prod values file
PROD_FILE="overlays/prod/values/demo-api-values.yaml"
LAST_COMMIT=$(git log -n 1 --pretty=format:%H -- "$PROD_FILE")

echo "Reverting commit: $LAST_COMMIT"
git revert "$LAST_COMMIT" --no-edit

echo "Commit reverted. Now pushing to main..."
git push origin main

echo "Rollback triggered. ArgoCD will sync the reverted version automatically."
