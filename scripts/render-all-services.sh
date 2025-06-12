#!/bin/bash

# This script renders Helm manifests for all services in all environments.
# It reads every *-values.yaml file under overlays/<env>/values/
# and appends their rendered output to overlays/<env>/rendered.yaml

CHART_PATH="charts/base-chart"
ENVIRONMENTS=(dev staging prod)

echo "🔁 Rendering Rollout manifests for all services..."

for env in "${ENVIRONMENTS[@]}"; do
  echo "📁 Environment: $env"
  
  OUTPUT_FILE="overlays/${env}/rendered.yaml"
  echo "# Generated rollout manifests for ${env}" > "$OUTPUT_FILE"

  for values_file in overlays/${env}/values/*-values.yaml; do
    service_name=$(basename "$values_file" | cut -d'-' -f1)
    
    echo "  🔹 Rendering $service_name..."

    helm template "$service_name" "$CHART_PATH" \
      -f "$values_file" >> "$OUTPUT_FILE"

    echo "---" >> "$OUTPUT_FILE"
  done

  echo "✅ Rendered: $OUTPUT_FILE"
done
