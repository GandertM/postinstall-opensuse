#!/usr/bin/env bash

#
# system-packages.sh
#

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps for default ~~~~~~~~~~~~~~~~~~~~~~~~~~

# required for all
install_app "wget"
install_app "curl"
install_app "git"
install_app "flatpak"

# required for swap
install_app "systemd-zram-service"

# required for shell
install_app "zsh"
install_app "tar"
install_app "tree"
install_app "unzip"
install_app "fontconfig"
install_app "mlocate"
install_app "btop"
install_app "starship"
install_app "stow"
install_app "wine"

# required for network
source "./apps/app-install-autofs.sh"

# Mozilla
#install_app "MozillaFirefox" # relative old / warning from bank / over to flatpak
install_app "MozillaThunderbird"

# Multimedia
install_app "abcde"
install_app "flac"
install_app "dragonplayer"
install_app "dragonplayer-lang"

# editor
install_app "micro-editor"
install_app "kate"

# required for desktop
install_app "yakuake"
install_app "plasma-vault"

# tools
install_app "dolphin"
install_app "btop"
install_app "syncthing"
install_app "barrier"
install_app "zip"
install_app "eza"
install_app "gdu"
install_app "xkill"
install_app "mc"
install_app "partitionmanager"
install_app "lynis"

# required for krusader
install_app "krusader"
install_app "arj"
install_app "kget"
install_app "kompare"
install_app "krename"
install_app "7zip"
install_app "lha"
install_app "unrar"
install_app "unzip"
install_app "zip"

# development
install_app "shfmt"
install_app "ShellCheck"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps from utilities ~~~~~~~~~~~~~~~~~~~~~~~~~~

install_app "bat" "utilities"           # Better cat
install_app "dust" "utilities"          # Better ncdu
install_app "fastfetch" "utilities"
install_app "trash-cli" "utilities"     # Saver rm
install_app "fzf" "utilities"
install_app "zoxide" "utilities"        # Better cd
install_app "tealdeer" "utilities"
install_app "multitail" "utilities"
install_app "ripgrep" "utilities"       # Better grep
install_app "opi" "utilities"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps from paulcarroty ~~~~~~~~~~~~~~~~~~~~~~~~~~

install_app "codium" "gitlab.com_paulcarroty_vscodium_repo"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps via opi ~~~~~~~~~~~~~~~~~~~~~~~~~~

opi codecs                              # adds packman and installs codecs from packman

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps from packman ~~~~~~~~~~~~~~~~~~~~~~~~~~

install_app "rar" "packman"             # required for krusader

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~
