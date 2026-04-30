#!/usr/bin/env bash

#
# repos/repo-add-packman-essentials.sh
#

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ adding repository ~~~~~~~~~~~~~~~~~~~~~~~~~~

if check_leap; then
	if zypper lr | grep -q "packman-essentials"; then
		log_message "INFO" "Repository packman-essentials already exists."
	else
		log_message "ADDING" "Adding repository packman-essentials"
		sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/Essentials' packman-essentials || log_message "ERROR" "Failed to update repository packman-essentials."
	fi
fi

if check_slowroll; then
	if zypper lr | grep -q "packman-essentials"; then
		log_message "INFO" "Repository packman-essentials already exists."
	else
		log_message "ADDING" "Adding repository packman-essentials"
		#sudo zypper addrepo -cfp 81 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Slowroll/Essentials' packman-essentials || log_message "ERROR" "Failed to update repository packman-essentials."
	fi
fi

if check_tumbleweed; then
	if zypper lr | grep -q "packman-essentials"; then
		log_message "INFO" "Repository packman-essentials already exists."
	else
		log_message "ADDING" "Adding repository packman-essentials"
		#sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/Essentials' packman-essentials || log_message "ERROR" "Failed to update repository packman-essentials."
	fi
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~