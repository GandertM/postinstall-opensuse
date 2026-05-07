#!/usr/bin/env bash

# -----------------------------------
# renoving busybox-hostname is exists
# -----------------------------------

if app_exists "busybox-hostname"; then
    
    sudo zypper --non-interactive remove busybox-hostname
    
    if test $? -eq 0; then
	    log_message "REMOVE" "busybox-hostname removed successfully."
	else
		log_message "ERROR" "Failed to remove busybox-hostname."
		exit 1
	fi

else

    log_message "INFO" "busybox-hostname not present on system."

fi

# -----------------------------------
# installing cockpit
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
