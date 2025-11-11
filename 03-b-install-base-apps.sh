#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-03-${TIMESTAMP}.log"

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
    # required for all
    APPS_LIST=(
        "wget"
        "curl"
        "git"
        "flatpak"
    )

    # required for shell
    APPS_LIST+=(
        "zsh"
        "tar"
        "bat"
        "tree"
        "fastfetch"
        "unzip"
        "fontconfig"
        "mlocate"
        "htop"
        "stow"
        "wine"
    )

    # required for network
    APPS_LIST+=(
        "autofs"
        "net-tools-deprecated"
    )

    # required for Mozilla
    APPS_LIST+=(
        "MozillaFirefox"
        "MozillaThunderbird"
    )

    # required for fonts
    APPS_LIST+=(
        #"fetchmsttfonts"
        #"fira-code-fonts"
    )

    # required for micro
    APPS_LIST+=(
        "micro-editor"
    )

    # required for desktop
    APPS_LIST+=(
        #"plank"
        "yakuake"
        "plasma-vault"
    )

    # required for tools
    APPS_LIST+=(
        "btop"
        "ShellCheck"
        #"pdfgrep"
        "yt-dlp"
        "syncthing"
        "barrier"
        "zip"
        "eza"
        "gdu"
        "xkill"
        "mc"
        "partitionmanager"
    )

    # required for krusader
    APPS_LIST+=(
        "kget"
        "kompare"
        "krename"
        "7zip"
        "lha"
        "unrar"
        "unzip"
        "zip"
    )

    APPS_EXCEPT_LIST=(
        "cockpit"
    )

    # actual installation
    for APP in "${APPS_LIST[@]}"; do
        
        if app_exists "$APP"; then
            log_message "INFO" "$APP is already installed, skipping installation."
        else
            log_message "INFO" "Installing $APP..."
            sudo zypper install -y "$APP" && log_message "INSTALL" "$APP installed successfully." || log_message "ERROR" "Failed to install $app_name."
        fi
        
    done

    # actual installation exceptions
    for APP in "${APPS_EXCEPT_LIST[@]}"; do
        
        if app_exists "$APP"; then
            log_message "INFO" "$APP is already installed, skipping installation."
        else
            log_message "INFO" "Installing $APP..."
            sudo zypper install "$APP" && log_message "INSTALL" "$APP installed successfully." || log_message "ERROR" "Failed to install $app_name."
        fi
        
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
