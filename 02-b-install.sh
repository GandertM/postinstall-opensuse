#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-02-${TIMESTAMP}.log"

# source release and functions
[[ -f /etc/os-release ]] && source /etc/os-release || log_message "ERROR" "Failed to source file os-release"
[[ -f ./core/system-functions.sh ]] && source ./core/system-functions.sh || log_message "ERROR" "Failed to source file system-functions.sh"

check_sudo
    
check_user_b

# add repositories
[[ -f ./repos/repo-add-packman-essentials.sh ]] && source ./repos/repo-add-packman-essentials.sh || log_message "ERROR" "Failed to source file repo-add-packman-essentials.sh"
[[ -f ./repos/repo-add-utilities.sh]] && source ./repos/repo-add-utilities.sh || log_message "ERROR" "Failed to source file repo-add-utilities.sh"
[[ -f ./repos/repo-add-flathub-user.sh]] && source ./repos/repo-add-flathub-user.sh || log_message "ERROR" "Failed to source file repo-add-flathub-user.sh"

# refresh repositories
[[ -f ./core/system-refresh.sh ]] && source ./core/system-refresh.sh || log_message "ERROR" "Failed to source file system-refresh.sh"

# required for all
install_app "wget"
install_app "curl"
install_app "git"
install_app "flatpak"

# required for shell
install_app "zsh"
install_app "tar"
install_app "bat"
install_app "tree"
install_app "fastfetch"
install_app "unzip"
install_app "fontconfig"
install_app "mlocate"
install_app "htop"
install_app "stow"
install_app "wine"

# required for network
install_app "autofs"
source ./apps/app-install-net-tools-deprecated.sh

# Mozilla
install_app "MozillaFirefox"
install_app "MozillaThunderbird"

# editor
install_app "micro-editor"

# required for desktop
install_app "yakuake"
install_app "plasma-vault"

# tools
install_app "btop"
install_app "ShellCheck"
#source ./apps/app-install-yt-dlp.sh  # not in default repo's anymore
#install_app "yt-dlp" # not in default repo's anymore
install_app "syncthing"
install_app "barrier"
install_app "zip"
install_app "eza"
install_app "gdu"
install_app "xkill"
install_app "mc"
install_app "partitionmanager"

# required for krusader
install_app "kget"
install_app "kompare"
install_app "krename"
install_app "7zip"
install_app "lha"
install_app "unrar"
install_app "unzip"
install_app "zip"

# from utilities
install_app "trash-cli" "utilities"
install_app "fzf" "utilities"
install_app "zoxide" "utilities"
install_app "tealdeer" "utilities"
install_app "multitail" "utilities"
install_app "ripgrep" "utilities"

# from packman-essentials
install_app "ffmpeg" "packman-essentials"
install_app "gstreamer-plugins-good" "packman-essentials"
install_app "gstreamer-plugins-bad" "packman-essentials"
install_app "gstreamer-plugins-ugly" "packman-essentials"
install_app "gstreamer-plugins-libav" "packman-essentials"
install_app "libavcodec" "packman-essentials"
install_app "vlc-codecs" "packman-essentials"

# required for system
#source ./apps/app-install-cockpit.sh  # use flatpak org.cockpit_project.CockpitClient / config not required
install_flatpak_user "org.cockpit_project.CockpitClient"

# speed up grub
set_grub

# check if reboot is required
[[ -f ./core/system-reboot.sh ]] && source ./core/system-reboot.sh || log_message "ERROR" "Failed to source file system-reboot.sh"
