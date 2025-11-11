#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-01-${TIMESTAMP}.log"

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

update_system() {  
    # Detect openSUSE variant
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        log_message "INFO" "Detected: '""$PRETTY_NAME""'"
    else
        log_message "ERROR" "Could not detect openSUSE version"
        return 1
    fi

    # Refreshing repositories
    log_message "REFRESH" "Refreshing repositories..."
    sudo zypper ref || log_message "ERROR" "Failed to update repositories"

    # Only run dist-upgrade (dup) on Slowroll or Tumbleweed
    log_message "UPDATE" "Updating repositories..."
    if echo "$ID" | grep -qiE 'tumbleweed|slowroll'; then
        sudo zypper dup || log_message "ERROR" "Could not update '""$ID""'"
    else
        sudo zypper up || log_message "ERROR" "Could not update '""$ID""'"
    fi
}

main() {
    log_message "FILE" "Start $(basename "$0")"
    sudo_check
    user_check "b"
    update_system
    log_message "FILE" "End $(basename "$0")"
}

main