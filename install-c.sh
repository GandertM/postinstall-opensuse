#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# 2026-04-14 created install script to get openSUSE up and running
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ------ ~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash settings ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~

# determine openSUSE release
[[ -f "/etc/os-release" ]] && source "/etc/os-release"

# logging
[[ -f "./core/functions.sh" ]] && source "./core/functions.sh"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Logging ~~~~~~~~~~~~~~~~~~~~~~~~~~

# create log-file
log_message "FILE" "Start $(basename "$0")"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Checks ~~~~~~~~~~~~~~~~~~~~~~~~~~

check_sudo

check_user_c

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Create snapshot PRE ~~~~~~~~~~~~~~~~~~~~~~~~~~

create_pre_snapshot

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Add flatpak repositories ~~~~~~~~~~~~~~~~~~~~~~~~~~

add_repo_flathub_user

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Refresh repositories ~~~~~~~~~~~~~~~~~~~~~~~~~~

system_refresh

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps from flathub ~~~~~~~~~~~~~~~~~~~~~~~~~~

# browsers
install_flatpak_user "org.mozilla.firefox"

# chat
install_flatpak_user "org.signal.Signal"

# passwords
install_flatpak_user "org.keepassxc.KeePassXC"

# backup
install_flatpak_user "com.borgbase.Vorta"

# audio & video
install_flatpak_user "com.spotify.Client"
install_flatpak_user "org.videolan.VLC"

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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Config user ~~~~~~~~~~~~~~~~~~~~~~~~~~

[[ -f "./user/user-c-configs.sh" ]] && source "./user/user-c-configs.sh"

# run configs
create_directories
install_meslo
install_firacode
install_dotfiles
stow_dotfiles
install_projects
#install_mc_theme
link_mounts

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Create snapshot POST ~~~~~~~~~~~~~~~~~~~~~~~~~~

create_post_snapshot

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Logging ~~~~~~~~~~~~~~~~~~~~~~~~~~

# close log-file
log_message "FILE" "End $(basename "$0")"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Reboot  ~~~~~~~~~~~~~~~~~~~~~~~~~~

system_reboot

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~