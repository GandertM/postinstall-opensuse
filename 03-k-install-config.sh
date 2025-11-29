#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-03-${TIMESTAMP}.log"

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

# system
install_flatpak_user "com.github.tchx84.Flatseal"
install_flatpak_user "org.cockpit_project.CockpitClient"

# additional browser
install_flatpak_user "io.github.ungoogled_software.ungoogled_chromium"

# development
install_flatpak_user "com.vscodium.codium"

# chat
install_flatpak_user "org.signal.Signal"

# passwords
install_flatpak_user "org.keepassxc.KeePassXC"

# backup
install_flatpak_user "com.borgbase.Vorta"

# audio & video
install_flatpak_user "com.spotify.Client"
install_flatpak_user "org.freac.freac"
install_flatpak_user "org.musicbrainz.Picard"
install_flatpak_user "org.videolan.VLC"

# download
install_flatpak_user "io.github.aandrew_me.ytdn"

# youtube
install_flatpak_user "io.freetubeapp.FreeTube"

# note taking
install_flatpak_user "md.obsidian.Obsidian"
install_flatpak_user "com.logseq.Logseq"

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

create_directories() {
    # required for k
    DIR_LIST=(
        ".config/fastfetch"
        ".config/mc"
        ".config/starship"
        ".config/zsh"
        ".crd"
        ".ssh"
        ".dotfiles"
        "bin"
        "projects"
        "mounts"
        "journals"
        "notes"
        "restores"
        "virtmachs"
    )

    # goto $HOME
    cd "$HOME"

    # actual creation
    for DIR in "${DIR_LIST[@]}" ; do
        
        if [[ -d "$DIR" ]]; then
            log_message "INFO" "$DIR exists, skipping creation."
        else
            log_message "INFO" "Creating $DIR..."
            
            mkdir -p "$DIR"

            if test $? -eq 0; then
                log_message "CREATE" "$DIR created successfully."
            else
                log_message "ERROR" "Failed to create $DIR."
                exit 1
            fi
        fi
        
    done

}

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

install_dotfiles() {
    log_message "-------" "Install projects."
    local DIR_DOTS="$HOME/.dotfiles"
    cd "$HOME"
    if [[ ! -d "$DIR_DOTS" ]]; then
        mkdir -p "$DIR_DOTS"
    fi

    git clone https://github.com/GandertM/dotfiles.git "$DIR_DOTS"

    if test $? -eq 0; then
        log_message "INFO" "Dotfiles cloned successfully."
    else
        log_message "ERROR" "Dotfiles not cloned."
        exit 1
    fi

}

stow_dotfiles() {
    log_message "-------" "Stow dotfiles."
    local DIR_DOTS="$HOME/.dotfiles"

    # stow dotfiles from list
    STOW_LIST=(
        "fastfetch"
        "mc"
        "starship"
        "zsh"
        "vim"
    )

    cd "$DIR_DOTS"

    # actual stowing
    for APP in "${STOW_LIST[@]}"; do
        
        log_message "INFO" "Creating $APP..."
        
        stow "$APP"

        if test $? -eq 0; then
            log_message "INFO" "$APP stowed successfully."
        else
            log_message "ERROR" "$APP not stowed."
            exit 1
        fi

    done

    cd "$HOME"
}

install_projects() {
    log_message "-------" "Install projects."
    local DIR_PROJECTS="$HOME/projects"
    cd "$HOME"
    if [[ ! -d "$DIR_PROJECTS" ]]; then
        mkdir -p "$DIR_PROJECTS"
    fi
    cd "$DIR_PROJECTS"
    
    git clone https://github.com/GandertM/postinstall.git

    if test $? -eq 0; then
        log_message "INFO" "Project 'postinstall' installed successfully."
    else
        log_message "ERROR" "Project 'postinstall' not installed."
        exit 1
    fi

    git clone https://github.com/GandertM/postinstall-opensuse.git
    
    if test $? -eq 0; then
        log_message "INFO" "Project 'postinstall-opensuse' installed successfully."
    else
        log_message "ERROR" "Project 'postinstall-opensuse' not installed."
        exit 1
    fi
    
    cd "$HOME"
}

install_mc_theme() {
    log_message "-------" "Install Midnight Commander theme."
    local DIR_MC_THEME="$HOME/.local/share/mc/skins/"
    local DIR_DOWNLOAD="$HOME/Downloads/mctheme"

    cd "$HOME"

    if [[ ! -d "$DIR_MC_THEME" ]]; then
        mkdir -p "$DIR_MC_THEME"
    
        if [[ ! -d "$DIR_DOWNLOAD" ]]; then
            mkdir -p "$DIR_DOWNLOAD"
        fi

        cd "$DIR_DOWNLOAD"
        git clone https://github.com/dracula/midnight-commander.git
        cd "./midnight-commander/skins/"
        cp ./*.ini "$DIR_MC_THEME"
        cd "$HOME"
        log_message "INFO" "Midnight Commander theme installed successfully."
        
    else
        log_message "INFO" "Midnight Commander theme is already installed, skipping installation."
        return
    fi

    cd "$HOME" 
}

# run configs
create_directories
install_meslo
install_firacode
install_dotfiles
stow_dotfiles
install_projects
install_mc_theme

