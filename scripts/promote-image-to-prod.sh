#!/bin/bash

# Define file paths
STAGING_FILE="overlays/staging/values/demo-api-values.yaml"
PROD_FILE="overlays/prod/values/demo-api-values.yaml"

# Extract the current tag from staging values file using yq
TAG=$(yq '.image.tag' "$STAGING_FILE")

# Print what we're about to do
echo "Promoting image tag '$TAG' from staging to prod..."

# Update the prod values file to use the same tag
yq e ".image.tag = \"$TAG\"" -i "$PROD_FILE"

# Stage and commit the change
git add "$PROD_FILE"
git commit -m "Promote demo-api to production: $TAG"
