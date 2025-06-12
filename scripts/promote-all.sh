#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Script: promote-all.sh
# Purpose: Promote image tags from one environment to another for all services
# Usage:
#   ./promote-all.sh staging prod
# -----------------------------------------------------------------------------

FROM_ENV="${1:-staging}"
TO_ENV="${2:-prod}"

if [[ -z "$FROM_ENV" || -z "$TO_ENV" ]]; then
  echo "Usage: ./promote-all.sh <from-env> <to-env>"
  exit 1
fi

VALUES_DIR="overlays/${FROM_ENV}/values"
if [[ ! -d "$VALUES_DIR" ]]; then
  echo "❌ Error: Source environment values directory does not exist: $VALUES_DIR"
  exit 1
fi

echo "📦 Bulk promoting all services from $FROM_ENV → $TO_ENV..."

for FILE in "$VALUES_DIR"/*-values.yaml; do
  SERVICE=$(basename "$FILE" | sed 's/-values.yaml//')

  FROM_FILE="overlays/${FROM_ENV}/values/${SERVICE}-values.yaml"
  TO_FILE="overlays/${TO_ENV}/values/${SERVICE}-values.yaml"

  if [[ ! -f "$TO_FILE" ]]; then
    echo "⚠️  Skipping $SERVICE — no target values file found in $TO_ENV"
    continue
  fi

  TAG=$(yq '.image.tag' "$FROM_FILE")
  echo "🔄 Promoting $SERVICE: $TAG"

  yq e ".image.tag = \"$TAG\"" -i "$TO_FILE"
  git add "$TO_FILE"
  git commit -m "promote: ${SERVICE} ${FROM_ENV} → ${TO_ENV}: $TAG"
done

echo "✅ Bulk promotion complete. Push the changes to trigger ArgoCD sync."
