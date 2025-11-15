#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Refreshing repositories
log_message "REFRESH" "Refreshing repositories..."
sudo zypper ref && log_message "SUCCESS" "Refreshing repositories..." || log_message "ERROR" "Failed to refresh repositories"
