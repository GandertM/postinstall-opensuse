#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-02-${TIMESTAMP}.log"

# source functions
source ./core/system-functions.sh

check_sudo
    
check_user_b

# add repositories
source ./repos/repo-add-packman-essentials.sh
source ./repos/repo-add-utilities.sh

# refresh repositories
source ./core/system-refresh.sh

# required for all
source ./apps/app-install-wget.sh
source ./apps/app-install-curl.sh
source ./apps/app-install-git.sh
source ./apps/app-install-flatpak.sh

# required for shell
source ./apps/app-install-zsh.sh
source ./apps/app-install-tar.sh
source ./apps/app-install-bat.sh
source ./apps/app-install-tree.sh
source ./apps/app-install-fastfetch.sh
source ./apps/app-install-unzip.sh
source ./apps/app-install-fontconfig.sh
source ./apps/app-install-mlocate.sh
source ./apps/app-install-htop.sh
source ./apps/app-install-stow.sh
source ./apps/app-install-wine.sh

# system
source ./apps/app-install-cockpit.sh

# required for network
source ./apps/app-install-autofs.sh
source ./apps/app-install-net-tools-deprecated.sh

# Mozilla
source ./apps/app-install-MozillaFirefox.sh
source ./apps/app-install-MozillaThunderbird.sh

# micro
source ./apps/app-install-micro-editor.sh

# required for desktop
source ./apps/app-install-yakuake.sh
source ./apps/app-install-plasma-vault.sh

# tools
source ./apps/app-install-btop.sh
source ./apps/app-install-ShellCheck.sh
source ./apps/app-install-yt-dlp.sh
source ./apps/app-install-syncthing.sh
source ./apps/app-install-barrier.sh
source ./apps/app-install-zip.sh
source ./apps/app-install-eza.sh
source ./apps/app-install-gdu.sh
source ./apps/app-install-xkill.sh
source ./apps/app-install-mc.sh
source ./apps/app-install-partitionmanager.sh

# required for krusader
source ./apps/app-install-kget.sh
source ./apps/app-install-kompare.sh
source ./apps/app-install-krename.sh
source ./apps/app-install-7zip.sh
source ./apps/app-install-lha.sh
source ./apps/app-install-unrar.sh
source ./apps/app-install-unzip.sh
source ./apps/app-install-zip.sh

# from utilities
source ./apps/app-install-repo-trash-cli.sh
source ./apps/app-install-repo-fzf.sh
source ./apps/app-install-repo-zoxide.sh
source ./apps/app-install-repo-tealdeer.sh
source ./apps/app-install-repo-multitail.sh
source ./apps/app-install-repo-ripgrep.sh

# from packman-essentials
source ./apps/app-install-repo-ffmpeg.sh
source ./apps/app-install-repo-gstreamer-plugins-good.sh
source ./apps/app-install-repo-gstreamer-plugins-bad.sh
source ./apps/app-install-repo-gstreamer-plugins-ugly.sh
source ./apps/app-install-repo-gstreamer-plugins-libav.sh
source ./apps/app-install-repo-libavcodec.sh
source ./apps/app-install-repo-vlc-codecs.sh

# check if reboot is required
source ./core/system-reboot.sh