#!/bin/bash

# Check if Helm and yq are installed
command -v helm >/dev/null 2>&1 || { echo >&2 "Helm is required but it's not installed. Aborting."; exit 1; }
command -v yq >/dev/null 2>&1 || { echo >&2 "yq is required but it's not installed. Aborting."; exit 1; }

# Function to display usage
usage() {
    echo "Usage: $0 <chart_name_with_version>"
    echo "Example: $0 jenkins/jenkins:3.0.0"
    exit 1
}

# Check for correct number of arguments
if [ "$#" -ne 1 ]; then
    usage
fi

CHART_NAME=$1

# Extract the chart name and version from the input (chart_name:version)
CHART_NAME_ONLY=$(echo "$CHART_NAME" | cut -d':' -f1)
CHART_VERSION=$(echo "$CHART_NAME" | cut -d':' -f2)

# Template the chart values and extract container images using yq
if [ -z "$CHART_VERSION" ]; then
    echo "No version specified, using the latest version of the chart."
    helm template "$CHART_NAME_ONLY" | yq e '.. | select(has("image")) | .image' - > images.txt
else
    echo "Extracting container images from Helm chart: $CHART_NAME (version: $CHART_VERSION)..."
    helm template "$CHART_NAME_ONLY" --version "$CHART_VERSION" | yq e '.. | select(has("image")) | .image' - > images.txt
fi

# Print the extracted images
if [ -s images.txt ]; then
    echo "The following container images are found in the Helm chart:"
    cat images.txt
else
    echo "No container images found in the Helm chart."
fi

# Clean up temporary file
rm -f images.txt
