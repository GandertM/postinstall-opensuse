#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-05-${TIMESTAMP}.log"

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

install_apps() {
    
    # via Utilities
    APPS_UTIL_LIST=(
        "trash-cli"
        "fzf"
        "zoxide"
        "tealdeer"
        "multitail"
        "ripgrep"
    )
    
    # via Packman
    APPS_PACKMAN_LIST=(
        "ffmpeg" 
        "gstreamer-plugins-good" 
        "gstreamer-plugins-bad" 
        "gstreamer-plugins-ugly" 
        "gstreamer-plugins-libav" 
        "libavcodec" 
        "vlc-codecs"
    )

    # actual installation
    for APP in "${APPS_UTIL_LIST[@]}"; do
        
        log_message "INFO" "Installing $APP..."
        sudo zypper install --allow-vendor-change --from utilities -y "$APP" && log_message "INSTALL" "$APP installed successfully." || log_message "ERROR" "Failed to install $app_name."
       
    done

    for APP in "${APPS_PACKMAN_LIST[@]}"; do
        
        log_message "INFO" "Installing $APP..."
        sudo zypper install --allow-vendor-change --from packman-essentials -y "$APP" && log_message "INSTALL" "$APP installed successfully." || log_message "ERROR" "Failed to install $app_name."
       
    done

}

main() {
    log_message "FILE" "Start $(basename "$0")"
    sudo_check
    user_check "b"
    refresh_system
    install_apps
    log_message "FILE" "End $(basename "$0")"
}

main
