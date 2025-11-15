#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Reboot file
CHECK_FILE="$HOME/install-01-system-reboot.log"

# Reboot system
# condition: run only on first pass!
if [[ -f "$CHECK_FILE" ]]; then
    log_message "SKIPPING" "Skipping reboot"
    rm "$CHECK_FILE"
    exit 1
else
    log_message "REBOOT" "Rebooting system..."
    touch "$CHECK_FILE"
    sudo systemctl reboot now && log_message "SUCCESS" "Rebooting system..." || log_message "ERROR" "Rebooting system..."
if
