#!/bin/bash

# Inline function definitions
check_bin() { command -v "$1" >/dev/null 2>&1; }
fail_because() { echo "ERROR: $1" >&2; exit 1; }
log_info() { echo "INFO: $1"; }
log_error() { echo "ERROR: $1" >&2; }

# Function to install Helm
install_helm() {
    log_info "Installing Helm..."
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash || fail_because "Helm installation failed."
    check_bin "helm" || fail_because "Helm not found after installation."
    log_info "Helm installed successfully."
}

# Function to install Trivy manually with the specified commands
install_trivy() {
    log_info "Installing Trivy..."

    # Download Trivy tarball
    wget https://github.com/aquasecurity/trivy/releases/download/v0.30.0/trivy_0.30.0_Linux-64bit.tar.gz || fail_because "Failed to download Trivy."
    
    # Extract the downloaded tarball
    tar zxvf trivy_0.30.0_Linux-64bit.tar.gz || fail_because "Failed to extract Trivy tarball."
    
    # Move Trivy binary to /usr/local/bin
    sudo mv trivy /usr/local/bin/ || fail_because "Failed to move Trivy binary to /usr/local/bin."
    
    # Check if Trivy is available in the system
    if ! check_bin "trivy"; then
        log_error "Trivy not found after installation."
        exit 1
    fi

    # Output the installation directory and PATH
    log_info "Trivy successfully installed."
    log_info "Trivy is located at: $(which trivy)"

    # Clean up unnecessary files
    log_info "Cleaning up unnecessary files..."
    rm -f trivy_0.30.0_Linux-64bit.tar.gz || log_error "Failed to remove tarball."
    rm -f LICENSE README.md || log_error "Failed to remove LICENSE and README.md."
    rm -rf contrib || log_error "Failed to remove contrib directory."
    log_info "Cleanup completed."
}

# Function to check and install jq
install_jq() {
    log_info "Installing jq..."
    sudo apt-get install jq -y || fail_because "Failed to install jq."
    check_bin "jq" || fail_because "jq not found after installation."
    log_info "jq installed successfully."
}

# Function to check and install yq
install_yq() {
    log_info "Installing yq..."
    sudo apt-get install yq -y || fail_because "Failed to install yq."
    check_bin "yq" || fail_because "yq not found after installation."
    log_info "yq installed successfully."
}

# Check and install Helm
if ! check_bin "helm"; then
    install_helm
else
    log_info "Helm is already installed."
fi

# Check and install Trivy
if ! check_bin "trivy"; then
    install_trivy
else
    log_info "Trivy is already installed."
fi

# Check and install jq
if ! check_bin "jq"; then
    install_jq
else
    log_info "jq is already installed."
fi

# Check and install yq
if ! check_bin "yq"; then
    install_yq
else
    log_info "yq is already installed."
fi

log_info "All prerequisites are met."

