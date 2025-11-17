#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail


# -----------------------------------
# installing an application
# -----------------------------------

install_app_interactive "cockpit"


# -----------------------------------
# required configuration for cockpit
# -----------------------------------

# enable service
sudo systemctl enable --now cockpit.socket || log_message "ERROR" "Failed to enable cockpit"

# open firewall
sudo firewall-cmd --permanent --zone=public --add-service=cockpit || log_message "ERROR" "Failed to add cockpit to firewall"
sudo firewall-cmd --reload || log_message "ERROR" "Failed to reload firewall"

# show info
log_message "INFO" "Start cockpit in browser with: https://localhost:9090"