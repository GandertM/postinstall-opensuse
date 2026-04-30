#!/usr/bin/env bash

#
# user-k-flatpaks.sh
#

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps from flathub ~~~~~~~~~~~~~~~~~~~~~~~~~~

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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~
