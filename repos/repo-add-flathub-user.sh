#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail


# -----------------------------------
# adding flathub per user
# -----------------------------------

log_message "-------" "Install flathub."

# Install the Flathub repository if not already installed
log_message "INFO" "Checking for Flathub repository..."

if flatpak remote-list --user | grep -q "flathub"; then
    log_message "INFO" "Flathub repository is already installed, skipping."
else
    log_message "INFO" "Installing Flathub repository..."
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && log_message "INFO" "Flathub repository installed." || log_message "ERROR" "Failed to install Flathub repository."
fi