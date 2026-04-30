#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# 2026-04-14 created core/system-refresh.sh
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ------ ~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash settings ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Refresh repositories ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Refreshing repositories
log_message "REFRESH" "Refreshing repositories..."

sudo zypper ref

if test $? -eq 0; then
	log_message "SUCCESS" "Refreshing repositories..."
else
	log_message "ERROR" "Failed to refresh repositories"
	exit 1
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~
