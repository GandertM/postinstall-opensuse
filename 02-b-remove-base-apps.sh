#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-02-${TIMESTAMP}.log"

# source functions
source ./main-functions.sh

# Verify it is loaded 
if [ $? -ne 0 ]; then
  log_message "ERROR" "Error sourcing functions"
  exit 1
fi

remove_apps() {
    # remove 
    APPS_LIST=(
        #"MozillaFirefox-branding-openSUSE"
        "busybox-hostname"
    )

    # actual removal
    for APP in "${APPS_LIST[@]}"; do
        
        if app_exists "$APP"; then
            log_message "INFO" "Removing $APP..."
            sudo zypper remove -y "$APP" && log_message "REMOVE" "Removal $APP successfully." || log_message "ERROR" "Failed to remove $APP."
        else
            log_message "INFO" "$APP is already removed, skipping removal."
        fi
        
    done
}

main() {
    log_message "FILE" "Start $(basename "$0")"
    sudo_check
    user_b_check
    refresh_system
    remove_apps
    log_message "FILE" "End $(basename "$0")"
}

main
