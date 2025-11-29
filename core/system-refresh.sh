#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Refreshing repositories
log_message "REFRESH" "Refreshing repositories..."

sudo zypper ref

if test $? -eq 0; then
    log_message "SUCCESS" "Refreshing repositories..." 
else
    log_message "ERROR" "Failed to refresh repositories"
    exit 1
fi
