#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Function to log messages
log_message() {
  LEVEL=$1
  MESSAGE=$2
  NOW=$(date '+%Y-%m-%d %H:%M:%S')
  printf "%s | %-8s | %s\n" "$NOW" "$LEVEL" "$MESSAGE" >> "$LOGFILE"
}

# Check sudo
check_sudo() {
    # Check if the user has sudo rights
    if ! sudo -v &>/dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR User does not have sudo rights"
        exit 1
    fi
}

# Check current user B
check_user_b() {
    # Get the current username
    USER_NAME="$USER"
    BASE_LETTER="b"   

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

# Check current user K
check_user_k() {
    # Get the current username
    USER_NAME="$USER"
    BASE_LETTER="k"   

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

# Check current user C
check_user_c() {
    # Get the current username
    USER_NAME="$USER"
    BASE_LETTER="c"

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

# Check if flatpak is installed on OpenSUSE
flatpak_exists() {
    flatpak list | grep "$1" > /dev/null 2>&1
}

install_app() {
    APP="$1"  
              
    if app_exists "$APP"; then
        log_message "INFO" "$APP is already installed, skipping installation."
    else
        log_message "INFO" "Installing $APP..."
        sudo zypper --non-interactive install "$APP" && log_message "INSTALL" "$APP installed successfully." || log_message "ERROR" "Failed to install $APP."
    fi
}

install_app_interactive() {
    APP="$1"  
              
    if app_exists "$APP"; then
        log_message "INFO" "$APP is already installed, skipping installation."
    else
        log_message "INFO" "Installing $APP..."
        sudo zypper install "$APP" && log_message "INSTALL" "$APP installed successfully." || log_message "ERROR" "Failed to install $APP."
    fi
}

install_app_repo() {
    REPO="$1"
    APP="$2"
    
    if zypper lr | grep -q "$REPO"; then
        log_message "INFO" "Installing $APP from $REPO..."
        sudo zypper --non-interactive install --allow-vendor-change --from "$REPO" "$APP" && log_message "INSTALL" "$APP installed successfully." || log_message "ERROR" "Failed to install $app_name."
    else
        log_message "ERROR" "Installing $APP from $REPO failed. Repository not present."
    fi
}

remove_app() {
    APP="$1" 

    if app_exists "$APP"; then
        log_message "INFO" "Removing $APP..."
        sudo zypper remove -y "$APP" && log_message "REMOVE" "$APP removed successfully." || log_message "ERROR" "Failed to remove $APP."
    else
        log_message "INFO" "$APP is not installed, skipping removal."
    fi
}
