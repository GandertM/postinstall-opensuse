#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-07-${TIMESTAMP}.log"

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
      #  "projects"
        "shared"
        "journals"
        "notes"
        "restores"
        "vm"
    )

    # goto $HOME
    cd "$HOME"

    # actual creation
    for DIR in "${DIR_LIST[@]}"; do
        
        if [[ -d "$DIR" ]]; then
            log_message "INFO" "$DIR exists, skipping creation."
        else
            log_message "INFO" "Creating $DIR..."
            mkdir -p "$DIR" && log_message "CREATE" "$DIR created successfully." || log_message "ERROR" "Failed to create $DIR."
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
    git clone https://github.com/GandertM/dotfiles.git "$DIR_DOTS" && log_message "INFO" "Dotfiles cloned successfully." || log_message "ERROR" "Dotfiles not cloned."
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
    )

    cd "$DIR_DOTS"

    # actual stowing
    for APP in "${STOW_LIST[@]}"; do
        
        log_message "INFO" "Creating $APP..."
        stow "$APP" && log_message "INFO" "$APP stowed successfully." || log_message "ERROR" "$APP not stowed."
       
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
    git clone https://github.com/GandertM/postinstall.git && log_message "INFO" "Project 'postinstall' installed successfully." || log_message "ERROR" "Project 'postinstall' not installed."
    git clone https://github.com/GandertM/postinstall-opensuse.git && log_message "INFO" "Project 'postinstall-opensuse' installed successfully." || log_message "ERROR" "Project 'postinstall-opensuse' not installed."
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
        cp *.ini "$DIR_MC_THEME"
        cd "$HOME"
        log_message "INFO" "Midnight Commander theme installed successfully."
        
    else
        log_message "INFO" "Midnight Commander theme is already installed, skipping installation."
        return
    fi

    cd "$HOME" 
}

main() {
    log_message "FILE" "Start $(basename "$0")"
    sudo_check
    user_check "k"
    refresh_system
    create_directories
    install_meslo
    install_firacode
    install_dotfiles
    stow_dotfiles
    install_projects
    install_mc_theme
    log_message "FILE" "End $(basename "$0")"
}

main
