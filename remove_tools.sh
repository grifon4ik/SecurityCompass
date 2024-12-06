#!/bin/bash

# Inline function definitions
check_bin() { command -v "$1" >/dev/null 2>&1; }
log_info() { echo "INFO: $1"; }
log_error() { echo "ERROR: $1" >&2; }

# Function to remove Helm
remove_helm() {
    log_info "Removing Helm..."
    
    # Check if Helm is installed
    if check_bin "helm"; then
        sudo rm -f /usr/local/bin/helm || log_error "Failed to remove Helm binary."
        sudo rm -rf ~/.helm || log_error "Failed to remove Helm config directory."
        sudo rm -rf /etc/helm || log_error "Failed to remove Helm system-wide config."
        log_info "Helm has been removed."
    else
        log_info "Helm is not installed."
    fi
}

# Function to remove Trivy
remove_trivy() {
    log_info "Removing Trivy..."
    
    # Check if Trivy is installed
    if check_bin "trivy"; then
        sudo rm -f /usr/local/bin/trivy || log_error "Failed to remove Trivy binary."
        rm -rf ~/.cache/trivy || log_error "Failed to remove Trivy cache."
        rm -rf ~/.trivy || log_error "Failed to remove Trivy config directory."
        log_info "Trivy has been removed."
    else
        log_info "Trivy is not installed."
    fi
}

# Function to remove jq
remove_jq() {
    log_info "Removing jq..."
    
    # Check if jq is installed
    if check_bin "jq"; then
        sudo apt-get remove --purge jq -y || log_error "Failed to remove jq."
        log_info "jq has been removed."
    else
        log_info "jq is not installed."
    fi
}

# Function to remove yq
remove_yq() {
    log_info "Removing yq..."
    
    # Check if yq is installed
    if check_bin "yq"; then
        sudo apt-get remove --purge yq -y || log_error "Failed to remove yq."
        log_info "yq has been removed."
    else
        log_info "yq is not installed."
    fi
}

# Remove Helm
remove_helm

# Remove Trivy
remove_trivy

# Remove jq
remove_jq

# Remove yq
remove_yq

log_info "Cleanup completed."
