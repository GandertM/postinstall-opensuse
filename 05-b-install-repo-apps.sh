#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-05-${TIMESTAMP}.log"

# source functions
source ./main-functions.sh

# Verify it is loaded 
if [ $? -ne 0 ]; then
  log_message "ERROR" "Error sourcing functions"
  exit 1
fi

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
    user_b_check
    refresh_system
    install_apps
    log_message "FILE" "End $(basename "$0")"
}

main
