#!/usr/bin/env bash
#
# system-function-logging.sh
#

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Logging ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Function to log messages
log_message() {
	LEVEL=$1
	MESSAGE=$2
	NOW=$(date '+%Y-%m-%d %H:%M:%S')
	printf "%s | %-8s | %s\n" "$NOW" "$LEVEL" "$MESSAGE" >>"$LOGFILE"

	if test $? -eq 0; then
		log_message "INFO" "Function logging successfully"
	else
		log_message "ERROR" "Error logging function"
		exit 1
	fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~