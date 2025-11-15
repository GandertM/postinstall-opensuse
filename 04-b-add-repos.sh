#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-04-${TIMESTAMP}.log"

# source functions
source ./main-functions.sh

# Verify it is loaded 
if [ $? -ne 0 ]; then
  log_message "ERROR" "Error sourcing functions"
  exit 1
fi

add_repos() {
  # install repo - utilities
  log_message "ADDING" "Adding repository utilities"
  sudo zypper addrepo -cfp 95 'https://download.opensuse.org/repositories/utilities/$releasever/' utilities || log_message "ERROR" "Failed to update repository utilities."

  # install repo - games
  #log_message "ADDING" "Adding repository games"
  #sudo zypper addrepo -cfp 95 'https://download.opensuse.org/repositories/games/$releasever/' games || log_message "ERROR" "Failed to update repository games."

  # install packman-essentials
  sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/Essentials' packman-essentials || log_message "ERROR" "Failed to update repository packman-essentials."

  # install repo - packman
  #log_message "ADDING" "Adding repository packman"
  #sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman || log_message "ERROR" "Failed to update repository packman."
  
}

main() {
    log_message "FILE" "Start $(basename "$0")"
    sudo_check
    user_b_check
    refresh_system
    add_repos
    log_message "FILE" "End $(basename "$0")"
}

main
