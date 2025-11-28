#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Reboot system if required
if [ -x /usr/bin/needs-restarting ]; then
	needs-restarting -r
	if [ $? -eq 1 ] ; then
        log_message "REBOOT" "Rebooting system..."
        sudo systemctl reboot || log_message "ERROR" "Rebooting system"
    else
        log_message "SKIPPING" "Reboot not required; skipping reboot"
    fi
fi