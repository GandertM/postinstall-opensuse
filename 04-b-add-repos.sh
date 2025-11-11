#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-04-${TIMESTAMP}.log"

# Function to log messages
log_message() {
  LEVEL=$1
  MESSAGE=$2
  NOW=$(date '+%Y-%m-%d %H:%M:%S')
  printf "%s | %-8s | %s\n" "$NOW" "$LEVEL" "$MESSAGE" >> "$LOGFILE"
}

# Check sudo
sudo_check() {
    # Check if the user has sudo rights
    if ! sudo -v &>/dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR User does not have sudo rights"
        exit 1
    fi
}

# Check current user
user_check() {
    # Ensure argument is provided
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <base_letter>."
        exit 1
    fi

    # Get the current username
    USER_NAME="$USER"
    BASE_LETTER="$1"   

    # Extract the first letter
    FIRST_LETTER="${USER_NAME:0:1}"

    # Check if it equals 'b'
    if [[ "$FIRST_LETTER" == "$BASE_LETTER" ]]; then
        echo "The username starts with '""$BASE_LETTER""'."
    else
        echo "You are using the wrong user. The username should start with '""$BASE_LETTER""'."
        exit 1
    fi
}

# Check if package is installed on OpenSUSE
app_exists() {
  command -v "$1" > /dev/null 2>&1 || rpm -q "$1" > /dev/null 2>&1
}

refresh_system() {
  # Update repositories
  log_message "REFRESH" "Updating repositories..."
  sudo zypper refresh || log_message "ERROR" "Failed to update repositories"
}

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
    user_check "b"
    refresh_system
    add_repos
    log_message "FILE" "End $(basename "$0")"
}

main
