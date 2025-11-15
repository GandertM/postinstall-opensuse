#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-06-${TIMESTAMP}.log"

# source functions
source ./main-functions.sh

# Verify it is loaded 
if [ $? -ne 0 ]; then
  log_message "ERROR" "Error sourcing functions"
  exit 1
fi

set_cockpit() {
    # enable cockpit
    sudo systemctl enable --now cockpit.socket || log_message "ERROR" "Failed to enable cockpit"

    # open firewall
    sudo firewall-cmd --permanent --zone=public --add-service=cockpit || log_message "ERROR" "Failed to add cockpit to firewall"
    sudo firewall-cmd --reload || log_message "ERROR" "Failed to reload firewall"

    # show info
    log_message "INFO" "Start cockpit in browser with: https://localhost:9090"
}

set_grub() {
    # change wait seconds of grub (from 8 to 2)
    sudo sed -i "s/GRUB_TIMEOUT=8/GRUB_TIMEOUT=2/gI" /etc/default/grub

    # process changes
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg || log_message "ERROR" "Failed to change grub"
}

main() {
    log_message "FILE" "Start $(basename "$0")"
    sudo_check
    user_b_check
    refresh_system
    set_cockpit
    set_grub
    log_message "FILE" "End $(basename "$0")"
}

main
