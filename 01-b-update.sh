#!/usr/bin/env bash
set -euo pipefail # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-01-${TIMESTAMP}.log"

# ----------------------------------------
# source functions and distro
# ----------------------------------------

if [ -f ./core/system-functions.sh ]; then

	# source functions
	source ./core/system-functions.sh

	if test $? -eq 0; then
		log_message "INFO" "Function sourced successfully"
	else
		log_message "ERROR" "Error sourcing functions"
		exit 1
	fi

fi

if [ -f /etc/os-release ]; then

	# source release
	source /etc/os-release

	if test $? -eq 0; then
		log_message "INFO" "Detected: '""$PRETTY_NAME""'"
	else
		log_message "ERROR" "Failed to detect openSUSE version"
		exit 1
	fi

fi

log_message "FILE" "Start $(basename "$0")"

# ----------------------------------------
# basis checks
# ----------------------------------------
check_sudo

check_user_b

# ----------------------------------------
# create a system snapshot
# ----------------------------------------
create_snapshot "pre"

# ----------------------------------------
# processing
# ----------------------------------------

if [ -f ./core/system-refresh.sh ]; then

	# source refresh
	source ./core/system-refresh.sh

	if test $? -eq 0; then
		log_message "INFO" "Refresh sourced successfully"
	else
		log_message "ERROR" "Error sourcing refresh"
		exit 1
	fi

fi

if [ -f ./core/system-update.sh ]; then

	# source refresh
	source ./core/system-update.sh

	if test $? -eq 0; then
		log_message "INFO" "Update sourced successfully"
	else
		log_message "ERROR" "Error sourcing update"
		exit 1
	fi

fi

if [ -f ./core/system-reboot.sh ]; then

	# source refresh
	source ./core/system-reboot.sh

	if test $? -eq 0; then
		log_message "INFO" "Reboot sourced successfully"
	else
		log_message "ERROR" "Error sourcing reboot"
		exit 1
	fi

fi

# ----------------------------------------
# create a system snapshot
# ----------------------------------------
create_snapshot "post"

log_message "FILE" "End $(basename "$0")"
