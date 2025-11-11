#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-08-${TIMESTAMP}.log"

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

flatpak_exists() {
    flatpak list | grep "$1" > /dev/null 2>&1
}

refresh_system() {
  # Update repositories
  log_message "REFRESH" "Updating repositories..."
  sudo zypper refresh || log_message "ERROR" "Failed to update repositories"
}

install_flathub() {
  log_message "-------" "Install flathub."

  # Install the Flathub repository if not already installed
  log_message "INFO" "Checking for Flathub repository..."
  if flatpak remote-list --user | grep -q "flathub"; then
    log_message "INFO" "Flathub repository is already installed, skipping."
  else
    log_message "INFO" "Installing Flathub repository..."
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && log_message "INFO" "Flathub repository installed." || log_message "ERROR" "Failed to install Flathub repository."
  fi
}

install_flatpaks() {
    # flatpaks
    APPS_LIST=(
        
        # security
        "com.github.tchx84.Flatseal"
        "io.github.flattool.Warehouse"
        "org.keepassxc.KeePassXC"
        
        # development
        "com.vscodium.codium"
        
        # tools
        "com.github.qarmin.czkawka"
        "org.kde.akregator"
        "org.kde.ark"
        "org.nmap.Zenmap"
        
        # backup
        "com.borgbase.Vorta"
        
        # audio & video
        "com.spotify.Client"
        "org.freac.freac"
        "org.musicbrainz.Picard"
        "org.videolan.VLC"
        
        # download
        "io.github.aandrew_me.ytdn"
        "io.freetubeapp.FreeTube"
        
        # note taking
        "md.obsidian.Obsidian"
        "com.logseq.Logseq"
        
        # KDE
        "org.kde.digikam"
        "org.kde.elisa"
        "org.kde.kcolorchooser"
        
        # KDE games
        "org.kde.kmahjongg"
        "org.kde.knights"
        
        # office
        "org.onlyoffice.desktopeditors"
        
        # others
        "com.calibre_ebook.calibre"
    )

    # actual installation
    for APP in "${APPS_LIST[@]}"; do
        
        if flatpak list --app | grep -q "$APP"; then
            log_message "INFO" "$APP is already installed, skipping installation."
        else
            log_message "INFO" "Installing $APP..."
            flatpak install --user -y flathub "$APP" && log_message "INSTALL" "$APP installed successfully." || log_message "ERROR" "Failed to install $APP."
        fi
        
    done

}

main() {
    log_message "FILE" "Start $(basename "$0")"
    sudo_check
    user_check "k"
    refresh_system
    install_flathub
    install_flatpaks
    log_message "FILE" "End $(basename "$0")"
}

main
