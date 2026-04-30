#!/usr/bin/env bash

#
# system-function-users.sh
#

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ adding repository ~~~~~~~~~~~~~~~~~~~~~~~~~~

if check_leap; then
	if zypper lr | grep -q "packman"; then
		log_message "INFO" "Repository packman already exists."
	else
		log_message "ADDING" "Adding repository packman"
		sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman || log_message "ERROR" "Failed to update repository packman."
	fi
fi

if check_slowroll; then
	if zypper lr | grep -q "packman"; then
		log_message "INFO" "Repository packman already exists."
	else
		log_message "ADDING" "Adding repository packman"
		sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Slowroll/' packman || log_message "ERROR" "Failed to update repository packman."
	fi
fi

if check_tumbleweed; then
	if zypper lr | grep -q "packman"; then
		log_message "INFO" "Repository packman already exists."
	else
		log_message "ADDING" "Adding repository packman"
		sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman || log_message "ERROR" "Failed to update repository packman."
	fi
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~