#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# 2026-04-14 created install script to get openSUSE up and running
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ------ ~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash settings ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~

# determine openSUSE release
[[ -f "/etc/os-release" ]] && source "/etc/os-release"

# logging
[[ -f "./core/system-function-logging.sh" ]] && source "./core/system-function-logging.sh"

# user management
#[[ -f "./core/system-function-users.sh" ]] && source "./core/system-function-users.sh"

# packages
#[[ -f "./core/system-function-packages.sh" ]] && source "./core/system-function-packages.sh"

# config
[[ -f "./user/user-c-configs.sh" ]] && source "./user/user-c-configs.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Logging ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Create a timestamp for the log-file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')

# create the name of the log-file
LOGFILE="$HOME/install-b-${TIMESTAMP}.log"

# create log-file
log_message "FILE" "Start $(basename "$0")"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Checks ~~~~~~~~~~~~~~~~~~~~~~~~~~

check_sudo

check_user_c

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Create snapshot PRE ~~~~~~~~~~~~~~~~~~~~~~~~~~

PRE_ID=$(sudo snapper create --type pre --print-number --description "Start initial installation for c")

if test $? -eq 0; then
	log_message "INFO" "PRE-snapshot $PRE_ID created successfully"
else
	log_message "ERROR" "Error creating PRE-snapshot"
	exit 1
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Add repositories ~~~~~~~~~~~~~~~~~~~~~~~~~~

# [[ -f "./repos/repo-add-packman.sh" ]] && source "./repos/repo-add-packman.sh"  # done via opi

# [[ -f "./repos/repo-add-utilities.sh" ]] && source "./repos/repo-add-utilities.sh"

# [[ -f "./repos/repo-add-gitlab.com_paulcarroty_vscodium_repo.sh" ]] && source "./repos/repo-add-gitlab.com_paulcarroty_vscodium_repo.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Add flatpak repositories ~~~~~~~~~~~~~~~~~~~~~~~~~~

[[ -f "./repos/repo-add-flathub-user.sh" ]] && source "./repos/repo-add-flathub-user.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Refresh repositories ~~~~~~~~~~~~~~~~~~~~~~~~~~

[[ -f "./core/system-refresh.sh" ]] && source "./core/system-refresh.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Install apps ~~~~~~~~~~~~~~~~~~~~~~~~~~

# [[ -f "./core/system-packages.sh" ]] && source "./core/system-packages.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Install flatpaks ~~~~~~~~~~~~~~~~~~~~~~~~~~

[[ -f "./user/user-c-flatpaks.sh" ]] && source "./user-c-flatpaks.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Config system ~~~~~~~~~~~~~~~~~~~~~~~~~~

# speed up grub
# set_grub

# activate swap
# sudo zramswapon

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Config user ~~~~~~~~~~~~~~~~~~~~~~~~~~

[[ -f "./user/user-c-configs.sh" ]] && source "./user-c-configs.sh"

# run configs
create_directories
install_meslo
install_firacode
install_dotfiles
stow_dotfiles
install_projects
#install_mc_theme
link_mounts

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Update  ~~~~~~~~~~~~~~~~~~~~~~~~~~

[[ -f "./core/system-update.sh" ]] && source "./core/system-update.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Create snapshot POST ~~~~~~~~~~~~~~~~~~~~~~~~~~

POST_ID=$(sudo snapper create --type post --pre-number "$PRE_ID" --print-number --description "End initial installation for c")

if test $? -eq 0; then
	log_message "INFO" "POST snapshot $POST_ID created successfully and linked to PRE-snapshot $PRE_ID"
else
	log_message "ERROR" "Error creating POST-snapshot"
	exit 1
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~