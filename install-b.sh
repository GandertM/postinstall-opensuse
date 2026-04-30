#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ------ ~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ------ ~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# 2026-04-14 created install script to get openSUSE up and running
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ------ ~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ------ ~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ------ ~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash settings ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Sourcing ~~~~~~~~~~~~~~~~~~~~~~~~~~

# determine openSUSE release
[[ -f "/etc/os-release" ]] && source "/etc/os-release"

# logging
[[ -f "./core/system-function-logging.sh" ]] && source "./core/system-function-logging.sh"

# user management
[[ -f "./core/system-function-users.sh" ]] && source "./core/system-function-users.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Logging ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Create a timestamp for the log-file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')

# create the name of the log-file
LOGFILE="$HOME/install-b-${TIMESTAMP}.log"

# create log-file
log_message "FILE" "Start $(basename "$0")"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Checks ~~~~~~~~~~~~~~~~~~~~~~~~~~

check_sudo

check_user_b

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Add user ~~~~~~~~~~~~~~~~~~~~~~~~~~

add_user

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~