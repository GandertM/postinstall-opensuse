#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# install-b.sh
#
# 2026-04-14 created install script to get openSUSE up and running
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash settings ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Sourcing ~~~~~~~~~~~~~~~~~~~~~~~~~~

# functions
[[ -f "./core/functions.sh" ]] && source "./core/functions.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Logging ~~~~~~~~~~~~~~~~~~~~~~~~~~

# create log-file
log_message "FILE" "Start $(basename "$0")"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Checks ~~~~~~~~~~~~~~~~~~~~~~~~~~

check_sudo

check_user_k

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Create snapshot PRE ~~~~~~~~~~~~~~~~~~~~~~~~~~

create_pre_snapshot

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Add repositories ~~~~~~~~~~~~~~~~~~~~~~~~~~

add_repo_packman

add_repo_utilities

add_repo_vscodium

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Add flatpak repositories ~~~~~~~~~~~~~~~~~~~~~~~~~~

add_repo_flathub_user

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Refresh repositories ~~~~~~~~~~~~~~~~~~~~~~~~~~

system_refresh

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Install apps ~~~~~~~~~~~~~~~~~~~~~~~~~~

# [[ -f "./core/system-packages.sh" ]] && source "./core/system-packages.sh"

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
install_app "barrier"        # input leap
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

install_app "opi" "utilities"			# opi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps from paulcarroty ~~~~~~~~~~~~~~~~~~~~~~~~~~

install_app "codium" "gitlab.com_paulcarroty_vscodium_repo"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps via opi ~~~~~~~~~~~~~~~~~~~~~~~~~~

opi codecs                              # installs codecs from packman

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps from packman ~~~~~~~~~~~~~~~~~~~~~~~~~~

install_app "rar" "packman"             # required for krusader

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps from flathub ~~~~~~~~~~~~~~~~~~~~~~~~~~

# browsers
install_flatpak_user "org.mozilla.firefox"

# system
install_flatpak_user "com.github.tchx84.Flatseal"
install_flatpak_user "org.cockpit_project.CockpitClient"

# additional browser
install_flatpak_user "io.github.ungoogled_software.ungoogled_chromium"

# development
#install_flatpak_user "com.vscodium.codium"

# chat
install_flatpak_user "org.signal.Signal"

# passwords
install_flatpak_user "org.keepassxc.KeePassXC"

# backup
install_flatpak_user "com.borgbase.Vorta"

# encyption
install_flatpak_user "org.cryptomator.Cryptomator"

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
install_flatpak_user "org.libreoffice.LibreOffice"

# ebook
install_flatpak_user "com.calibre_ebook.calibre"

# tools
install_flatpak_user "com.github.qarmin.czkawka"
install_flatpak_user "org.kde.akregator"
install_flatpak_user "org.kde.ark"
install_flatpak_user "org.nmap.Zenmap"
install_flatpak_user "org.remmina.Remmina"


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Config user ~~~~~~~~~~~~~~~~~~~~~~~~~~

[[ -f "./user/user-k-configs.sh" ]] && source "./user-k-configs.sh"

# run configs
create_directories
install_meslo
install_firacode
install_jetbrainsmono
install_dotfiles
stow_dotfiles
install_projects
#install_mc_theme  # reverted to default, as for theme problems in kitty
link_mounts
install_ollama

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Update  ~~~~~~~~~~~~~~~~~~~~~~~~~~

system_update

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Create snapshot POST ~~~~~~~~~~~~~~~~~~~~~~~~~~

create_post_snapshot

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~