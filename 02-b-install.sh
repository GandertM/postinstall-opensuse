#!/usr/bin/env bash
set -euo pipefail # Safe bash scripting: exit on error, unset var, or pipe fail

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/install-02-${TIMESTAMP}.log"

# ----------------------------------------
# source functions and distro
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
# basic checks
# ----------------------------------------

check_sudo

check_user_b

# ----------------------------------------
# create a system snapshot
# ----------------------------------------
create_snapshot "pre"

# ----------------------------------------
# add repositories
# ----------------------------------------

# add repository - packman-essentials
if [ -f ./repos/repo-add-packman-essentials.sh ]; then

	# source refresh
	source ./repos/repo-add-packman-essentials.sh

	if test $? -eq 0; then
		log_message "INFO" "repo-add-packman-essentials.sh sourced successfully"
	else
		log_message "ERROR" "Failed to source file repo-add-packman-essentials.sh"
		exit 1
	fi

fi

# add repository - utilities
if [ -f ./repos/repo-add-utilities.sh ]; then

	# source refresh
	source ./repos/repo-add-utilities.sh

	if test $? -eq 0; then
		log_message "INFO" "repo-add-utilities.sh sourced successfully"
	else
		log_message "ERROR" "Failed to source file repo-add-utilities.sh"
		exit 1
	fi

fi

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

# add repository - gitlab.com_paulcarroty_vscodium_repo
if [ -f ./repos/repo-add-gitlab.com_paulcarroty_vscodium_repo.sh ]; then

	# source refresh
	source ./repos/repo-add-gitlab.com_paulcarroty_vscodium_repo.sh

	if test $? -eq 0; then
		log_message "INFO" "repo-add-gitlab.com_paulcarroty_vscodium_repo.sh sourced successfully"
	else
		log_message "ERROR" "Failed to source file repo-add-gitlab.com_paulcarroty_vscodium_repo.sh"
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

# ----------------------------------------
# install apps
# ----------------------------------------

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
#install_app "autofs"
source ./apps/app-install-autofs.sh
source ./apps/app-install-net-tools-deprecated.sh

# Mozilla
install_app "MozillaFirefox"
install_app "MozillaThunderbird"

# Multimedia
install_app "abcde"
install_app "flac"

# editor
install_app "micro-editor"
install_app "kate"

# required for desktop
install_app "yakuake"
install_app "plasma-vault"

# tools
install_app "dolphin"
install_app "btop"
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
install_app "krusader"
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

# from gitlab.com_paulcarroty_vscodium_repo
install_app "codium" "gitlab.com_paulcarroty_vscodium_repo"
install_app "shfmt"
install_app "ShellCheck"

# ----------------------------------------
# install flatpaks
# ----------------------------------------

# required for system
#source ./apps/app-install-cockpit.sh  # use flatpak org.cockpit_project.CockpitClient / config not required
install_flatpak_user "org.cockpit_project.CockpitClient"

# ----------------------------------------
# config
# ----------------------------------------

# speed up grub
set_grub

# ----------------------------------------
# create a system snapshot
# ----------------------------------------
create_snapshot "post"

# ----------------------------------------
# reboot
# ----------------------------------------

# check if reboot is required
if [ -f ./core/system-reboot.sh ]; then

	# source refresh
	source ./core/system-reboot.sh

	if test $? -eq 0; then
		log_message "INFO" "Reboot sourced successfully"
	else
		log_message "ERROR" "Error sourcing reboot"
		exit 1
	fi

fi
