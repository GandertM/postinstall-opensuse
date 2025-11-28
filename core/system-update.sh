#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Detect openSUSE variant
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    log_message "INFO" "Detected: '""$PRETTY_NAME""'"
else
    log_message "ERROR" "Failed to detect openSUSE version"
    return 1
fi

# Only run dist-upgrade (dup) on Slowroll or Tumbleweed
log_message "UPDATE" "Updating system..."
if echo "$ID" | grep -qiE 'tumbleweed|slowroll'; then
    sudo zypper --non-interactive dup && log_message "SUCCESS" "Distro-Updating system..." || log_message "ERROR" "Failed to update '""$ID""'"
else
    sudo zypper --non-interactive up && log_message "SUCCESS" "Updating system..." || log_message "ERROR" "Failed to update '""$ID""'"
fi