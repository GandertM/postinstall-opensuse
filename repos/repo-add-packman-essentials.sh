#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail


# -----------------------------------
# adding repository
# -----------------------------------

# add packman-essentials
log_message "ADDING" "Adding repository packman-essentials"
sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/Essentials' packman-essentials || log_message "ERROR" "Failed to update repository packman-essentials."
