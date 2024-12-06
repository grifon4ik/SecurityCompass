#!/bin/bash

check_bin() { command -v "$1" >/dev/null 2>&1; }
fail_because() { echo "ERROR: $1" >&2; exit 1; }
log_info() { echo "INFO: $1"; }

# Test functions
log_info "Testing check_bin for helm..."
if ! check_bin "helm"; then
    fail_because "Helm not found!"
fi
log_info "Helm is installed. Version: $(helm version --short)"

log_info "Testing check_bin for trivy..."
if ! check_bin "trivy"; then
    fail_because "Trivy not found!"
fi
log_info "Trivy is installed. Version: $(trivy --version)"

log_info "Testing check_bin for jq..."
if ! check_bin "jq"; then
    fail_because "jq not found!"
fi
log_info "jq is installed. Version: $(jq --version)"

log_info "Testing check_bin for yq..."
if ! check_bin "yq"; then
    fail_because "yq not found!"
fi
log_info "yq is installed. Version: $(yq --version)"

log_info "All tested tools are successfully installed and functional."
