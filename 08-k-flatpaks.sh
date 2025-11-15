#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-08-${TIMESTAMP}.log"

# source functions
source ./main-functions.sh

# Verify it is loaded 
if [ $? -ne 0 ]; then
  log_message "ERROR" "Error sourcing functions"
  exit 1
fi

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
    user_k_check
    refresh_system
    install_flathub
    install_flatpaks
    log_message "FILE" "End $(basename "$0")"
}

main
