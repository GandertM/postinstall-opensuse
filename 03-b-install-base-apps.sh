#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-03-${TIMESTAMP}.log"

# source functions
source ./main-functions.sh

# Verify it is loaded 
if [ $? -ne 0 ]; then
  log_message "ERROR" "Error sourcing functions"
  exit 1
fi

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
##
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
    user_b_check
    refresh_system
    install_apps
    log_message "FILE" "End $(basename "$0")"
}

main
