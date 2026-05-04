#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# install-swap.sh
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
# set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ installation ~~~~~~~~~~~~~~~~~~~~~~~~~~

# required for swap
install_app "systemd-zram-service"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ start service ~~~~~~~~~~~~~~~~~~~~~~~~~~

sudo zramswapon

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~