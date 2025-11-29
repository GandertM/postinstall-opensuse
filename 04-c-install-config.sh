#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-04-${TIMESTAMP}.log"

# ----------------------------------------
# source distro and functions
# ----------------------------------------

if [ -f ./core/system-functions.sh ]; then
    
    # source functions
    source ./core/system-functions.sh

    if test $? -eq 0; then
        log_message "INFO" "Function sourced successfully"
    else
        log_message "ERROR" "Error sourcing functions"
        exit 1
    fi

fi

if [ -f /etc/os-release ]; then

    # source release    
    source /etc/os-release

    if test $? -eq 0; then
        log_message "INFO" "Detected: '""$PRETTY_NAME""'"
    else
        log_message "ERROR" "Failed to detect openSUSE version"
        exit 1
    fi

fi


# ----------------------------------------
# basis checks
# ----------------------------------------

check_sudo
    
check_user_k


# ----------------------------------------
# add repositories
# ----------------------------------------

# add repository - flathub-user
if [ -f ./repos/repo-add-flathub-user.sh ]; then
    
    # source refresh
    source ./repos/repo-add-flathub-user.sh

    if test $? -eq 0; then
        log_message "INFO" "repo-add-flathub-user.sh sourced successfully"
    else
        log_message "ERROR" "Failed to source file repo-add-flathub-user.sh"
        exit 1
    fi

fi


# ----------------------------------------
# refresh repositories
# ----------------------------------------

if [ -f ./core/system-refresh.sh ]; then
    
    # source refresh
    source ./core/system-refresh.sh

    if test $? -eq 0; then
        log_message "INFO" "Refresh sourced successfully"
    else
        log_message "ERROR" "Error sourcing refresh"
        exit 1
    fi

fi


# -------------------------------------
# install - flatpaks
# -------------------------------------

# chat
install_flatpak_user "org.signal.Signal"

# passwords
install_flatpak_user "org.keepassxc.KeePassXC"

# backup
install_flatpak_user "com.borgbase.Vorta"

# audio & video
install_flatpak_user "org.videolan.VLC"

# download
install_flatpak_user "io.github.aandrew_me.ytdn"

# youtube
install_flatpak_user "io.freetubeapp.FreeTube"

# GTK theme
install_flatpak_user "org.gtk.Gtk3theme.Breeze"

# KDE
install_flatpak_user "org.kde.digikam"
install_flatpak_user "org.kde.elisa"
install_flatpak_user "org.kde.kcolorchooser"

# KDE games
install_flatpak_user "org.kde.kmahjongg"
install_flatpak_user "org.kde.knights"

# office
install_flatpak_user "org.onlyoffice.desktopeditors"


# -------------------------------------
# config
# -------------------------------------

install_meslo() {
  log_message "-------" "Install font."

  # Install font 'MesloLGSDZ Nerd Font 13pt' of 'MesloLGS Nerd Font Mono'
  FONT_NAME="MesloLGS Nerd Font Mono"
  if fc-list :family | grep -iq "$FONT_NAME"; then
      log_message "INFO" "Font '$FONT_NAME' is installed."
  else
      log_message "INFO" "Installing font '$FONT_NAME'"
      
      # Change this URL to correspond with the correct font
      FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
      FONT_DIR="$HOME/.local/share/fonts"
      
      # check if the file is accessible
      if wget -q --spider "$FONT_URL"; then
        TEMP_DIR=$(mktemp -d)
        wget -q --show-progress $FONT_URL -O "$TEMP_DIR"/"${FONT_NAME}".zip
        unzip "$TEMP_DIR"/"${FONT_NAME}".zip -d "$TEMP_DIR"
        mkdir -p "$FONT_DIR"/"$FONT_NAME"
        mv "${TEMP_DIR}"/*.ttf "$FONT_DIR"/"$FONT_NAME"
      
        # Update the font cache
        fc-cache -fv
      
        # Delete the files created from this
        rm -rf "${TEMP_DIR}"
        log_message "INFO" "'$FONT_NAME' installed successfully."
      else
        log_message "ERROR" "Font '$FONT_NAME' not installed. Font URL is not accessible."
      fi
  fi
}

install_firacode() {
  log_message "-------" "Install font."

  # Install font 'FiraCode Nerd Font'
  FONT_NAME="FiraCode Nerd Font"
  if fc-list :family | grep -iq "$FONT_NAME"; then
      log_message "INFO" "Font '$FONT_NAME' is installed."
  else
      log_message "INFO" "Installing font '$FONT_NAME'"
      
      # Change this URL to correspond with the correct font
      FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
      FONT_DIR="$HOME/.local/share/fonts"
      
      # check if the file is accessible
      if wget -q --spider "$FONT_URL"; then
        TEMP_DIR=$(mktemp -d)
        wget -q --show-progress $FONT_URL -O "$TEMP_DIR"/"${FONT_NAME}".zip
        unzip "$TEMP_DIR"/"${FONT_NAME}".zip -d "$TEMP_DIR"
        mkdir -p "$FONT_DIR"/"$FONT_NAME"
        mv "${TEMP_DIR}"/*.ttf "$FONT_DIR"/"$FONT_NAME"
      
        # Update the font cache
        fc-cache -fv
      
        # Delete the files created from this
        rm -rf "${TEMP_DIR}"
        log_message "INFO" "'$FONT_NAME' installed successfully."
      else
        log_message "ERROR" "Font '$FONT_NAME' not installed. Font URL is not accessible."
      fi
  fi
}

# run configs
install_meslo
install_firacode
