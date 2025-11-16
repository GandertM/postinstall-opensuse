#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-01-${TIMESTAMP}.log"

# source functions
source ./core/system-functions.sh

# Verify it is loaded 
#if [[ $? -ne 0 ]]; then
#  log_message "ERROR" "Error sourcing functions"
#  exit 1
#fi

log_message "FILE" "Start $(basename "$0")"
#sudo_check
#user_b_check
source ./core/system-refresh.sh
source ./core/system-update.sh
source ./core/system-reboot.sh
log_message "FILE" "End $(basename "$0")"
