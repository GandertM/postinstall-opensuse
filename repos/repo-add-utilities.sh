#!/usr/bin/env bash
set -euo pipefail # Safe bash scripting: exit on error, unset var, or pipe fail

# -----------------------------------
# adding repository
# -----------------------------------

# add utilities repo if not already installed

if check_leap; then
	if zypper lr | grep -q "utilities"; then
		log_message "INFO" "Repository utilities already exists."
	else
		log_message "ADDING" "Adding repository utilities"
		sudo zypper addrepo -cfp 95 'https://download.opensuse.org/repositories/utilities/$releasever/' utilities || log_message "ERROR" "Failed to update repository utilities."
	fi
fi

if check_slowroll; then
	if zypper lr | grep -q "utilities"; then
		log_message "INFO" "Repository utilities already exists."
	else
		log_message "ADDING" "Adding repository utilities"
		#sudo zypper addrepo -cfp 95 'https://download.opensuse.org/repositories/utilities/$releasever/' utilities || log_message "ERROR" "Failed to update repository utilities."
	fi
fi

if check_tumbleweed; then
	if zypper lr | grep -q "utilities"; then
		log_message "INFO" "Repository utilities already exists."
	else
		log_message "ADDING" "Adding repository utilities"
		#sudo zypper addrepo -cfp 95 'https://download.opensuse.org/repositories/utilities/$releasever/' utilities || log_message "ERROR" "Failed to update repository utilities."
	fi
fi
