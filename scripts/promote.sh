#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Script: promote.sh
# Purpose: Promote image tag from one environment to another for a given service
# Usage:
#   ./promote.sh demo-api staging prod
#   ./promote.sh demo-api              # defaults to staging -> prod
# -----------------------------------------------------------------------------

SERVICE="${1:-}"
FROM_ENV="${2:-staging}"
TO_ENV="${3:-prod}"

if [[ -z "$SERVICE" ]]; then
  echo "Error: Service name is required."
  echo "Usage: ./promote.sh <service-name> [from-env] [to-env]"
  exit 1
fi

FROM_FILE="overlays/${FROM_ENV}/values/${SERVICE}-values.yaml"
TO_FILE="overlays/${TO_ENV}/values/${SERVICE}-values.yaml"

if [[ ! -f "$FROM_FILE" || ! -f "$TO_FILE" ]]; then
  echo "Error: values.yaml not found for service '$SERVICE' in one of the environments."
  echo "FROM: $FROM_FILE"
  echo "TO:   $TO_FILE"
  exit 1
fi

# Extract image tag from source environment
TAG=$(yq '.image.tag' "$FROM_FILE")
echo "Promoting service: $SERVICE"
echo "From environment: $FROM_ENV"
echo "To environment:   $TO_ENV"
echo "Tag to promote:   $TAG"

# Patch target environment
yq e ".image.tag = \"$TAG\"" -i "$TO_FILE"

# Commit the promotion
git add "$TO_FILE"
git commit -m "promote: ${SERVICE} ${FROM_ENV} → ${TO_ENV}: $TAG"

echo "Promotion committed. Push to trigger ArgoCD sync."
