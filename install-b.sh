#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# install-b.sh
#
# 2026-04-14 created install script to get openSUSE up and running
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash settings ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Sourcing ~~~~~~~~~~~~~~~~~~~~~~~~~~

# functions
[[ -f "./core/functions.sh" ]] && source "./core/functions.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Logging ~~~~~~~~~~~~~~~~~~~~~~~~~~

# create log-file
log_message "FILE" "Start $(basename "$0")"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Checks ~~~~~~~~~~~~~~~~~~~~~~~~~~

check_sudo

check_user_b

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Config system ~~~~~~~~~~~~~~~~~~~~~~~~~~

set_grub

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Add user ~~~~~~~~~~~~~~~~~~~~~~~~~~

sudo add_user

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps ~~~~~~~~~~~~~~~~~~~~~~~~~~

system_refresh

# required for all
install_app "wget"
install_app "curl"
install_app "git"
install_app "flatpak"

# install autofs
[[ -f "./apps/install-autofs.sh" ]] && source "./apps/install-autofs.sh"

# install swap
[[ -f "./apps/install-swap.sh" ]] && source "./apps/install-swap.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Logging ~~~~~~~~~~~~~~~~~~~~~~~~~~

# close log-file
log_message "FILE" "End $(basename "$0")"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~