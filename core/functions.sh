#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# functions.sh
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
# set -euo pipefail       # exit on error, unset var, or pipe fail


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Logs ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d-%H-%M-%S')
LOGFILE="$HOME/postinstall_${TIMESTAMP}.log"

# Function to log messages
log_message() {
	LEVEL=$1
	MESSAGE=$2
	NOW=$(date '+%Y-%m-%d %H:%M:%S')
	printf "%s | %-8s | %s\n" "$NOW" "$LEVEL" "$MESSAGE" >>"$LOGFILE"

	# if test $? -eq 0; then
	# 	log_message "INFO" "Function logging successfully"
	# else
	# 	log_message "ERROR" "Error logging function"
	# 	exit 1
	# fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Outputs ~~~~~~~~~~~~~~~~~~~~~~~~~~

# blue line
line_blue() {
	# Drawing horizontal blue line in full width
	cols=$(tput cols)
	printf -v line "%*s" "$cols" ""
	printf "\e[34m%s\e[0m\n" "${line// /─}"
}

line_red() {
	# Drawing horizontal blue line in full width
	cols=$(tput cols)
	printf -v line "%*s" "$cols" ""
	printf "\e[31m%s\e[0m\n" "${line// /─}"
}

# text in color
text_color() {

	# Print a text ($2) with a color ($1)
	local input_color="$1"

	# Colors
	case "$input_color" in
	"Default") colorString='\033[0;39m' ;;
	"Black") colorString='\033[0;30m' ;;
	"DarkRed") colorString='\033[0;31m' ;;
	"DarkGreen") colorString='\033[0;32m' ;;
	"DarkYellow") colorString='\033[0;33m' ;;
	"DarkBlue") colorString='\033[0;34m' ;;
	"DarkMagenta") colorString='\033[0;35m' ;;
	"DarkCyan") colorString='\033[0;36m' ;;
	"Gray") colorString='\033[0;37m' ;;
	"DarkGray") colorString='\033[1;90m' ;;
	"Red") colorString='\033[1;91m' ;;
	"Green") colorString='\033[1;92m' ;;
	"Yellow") colorString='\033[1;93m' ;;
	"Blue") colorString='\033[1;94m' ;;
	"Magenta") colorString='\033[1;95m' ;;
	"Cyan") colorString='\033[1;96m' ;;
	"White") colorString='\033[1;97m' ;;
	*) colorString='\033[0;39m' ;;
	esac

	# Print the text
	printf "%b" "${colorString}" "$2" "\033[0m\n"

}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Users ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Function to add users
add_user() {

	# Ensure script is run as root
	# if [[ "$(id -u)" -ne 0 ]]; then
	# 	printf 'This script must be run as root.\n' >&2
	# 	exit 1
	# fi

	# Ask for first name
	read -r -p "Enter your first name: " firstname

	# Ensure input is not empty
	if [[ -z "$firstname" ]]; then
		printf 'First name cannot be empty.\n' >&2
		exit 1
	fi

	# Username: lowercase
	username="${firstname,,}"

	# Comment: capitalize first letter
	comment="${firstname^}"

	# Ask for password (silent)
	read -r -s -p "Enter password for ${username}: " password
	printf '\n'
	read -r -s -p "Confirm password: " password_confirm
	printf '\n'

	# Check passwords match
	if [[ "$password" != "$password_confirm" ]]; then
		printf 'Passwords do not match.\n' >&2
		exit 1
	fi

	# Extract the first letter
	FIRST_LETTER="${username:0:1}"

	# Set correct UID for NFS
	if [[ "$FIRST_LETTER" == "k" ]]; then
		ID="1027"
	elif [[ "$FIRST_LETTER" == "c" ]]; then
		ID="1028"
	else
		ID=""
	fi

	# Create the user
	if [[ -n "$ID" ]]; then
		
		# add user
		sudo useradd -m -u "$ID" -c "$comment" "$username"

		# add user to group wheel
		sudo usermod -a -G "wheel" "$username"

        # if test $? -eq 0; then
		#     log_message "INFO" "Function sourced successfully"
	    # else
		#     log_message "ERROR" "Error sourcing functions"
		#     exit 1
	    # fi

	else
		
		# add user
		sudo useradd -m -c "$comment" "$username"

		# add user to group wheel
		sudo usermod -a -G "wheel" "$username"

	fi

    if test $? -eq 0; then
	    log_message "INFO" "Adding user $username successfully"
    else
	    log_message "ERROR" "Error adding user $username"
	    exit 1
    fi

	# Set the password
	printf '%s:%s\n' "$username" "$password" | sudo chpasswd

    if test $? -eq 0; then
	    log_message "INFO" "Adding password for user $username successfully"
    else
	    log_message "ERROR" "Error adding password for user $username"
	    exit 1
    fi

	printf "User '%s' created successfully with comment '%s'.\n" "$username" "$comment"

}

# Check sudo
check_sudo() {
	# Check if the user has sudo rights
	if ! sudo -v &>/dev/null; then
		echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR User does not have sudo rights"
		exit 1
	fi
}

# Check current user B
check_user_b() {
	# Get the current username
	USER_NAME="$USER"
	BASE_LETTER="b"

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

# Check current user K
check_user_k() {
	# Get the current username
	USER_NAME="$USER"
	BASE_LETTER="k"

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

# Check current user C
check_user_c() {
	# Get the current username
	USER_NAME="$USER"
	BASE_LETTER="c"

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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ System ~~~~~~~~~~~~~~~~~~~~~~~~~~

# determine openSUSE release
[[ -f "/etc/os-release" ]] && source "/etc/os-release"

# check if LEAP
check_leap() {
	echo "$ID" | grep -qiE 'leap'
}

# check if SLOWROLL
check_slowroll() {
	echo "$ID" | grep -qiE 'slowroll'
}

# check if TUMBLEWEED
check_tumbleweed() {
	echo "$ID" | grep -qiE 'tumbleweed'
}

# Adjust GRUB2 from wait 8 to 0
set_grub() {

	if echo "$ID" | grep -qiE 'tumbleweed|slowroll'; then

		# change wait seconds of grub2-bls (from 8 to 0) in SLOWROLL or TUMBLEWEED
		if app_exists sdbootutil; then

			log_message "INFO" "Setting new timeout to 0 seconds"

			sudo sdbootutil set-timeout 0

			if test $? -eq 0; then
				log_message "INFO" "Update grub boottime successfull"
			else
				log_message "ERROR" "Failed to change grub boottime, grub2-mkconfig run into error."
				exit 1
			fi

		else

			log_message "ERROR" "Failed to change boottime, sdbootutil not present"

		fi

	else

		# change wait seconds of grub2 (from 8 to 0) in LEAP
		if [ -f /etc/default/grub ]; then

			sudo sed -i "s/GRUB_TIMEOUT=8/GRUB_TIMEOUT=0/gI" /etc/default/grub

			if test $? -eq 0; then
				log_message "INFO" "Update grub boottime successfull"
			else
				log_message "ERROR" "Failed to change grub boottime"
				exit 1
			fi

			# rebuild grub.cfg
			log_message "INFO" "Rebuilding grub.cfg..."

			sudo grub2-mkconfig -o /boot/grub2/grub.cfg

			if test $? -eq 0; then
				log_message "INFO" "Update grub boottime successfull"
			else
				log_message "ERROR" "Failed to change grub boottime, grub2-mkconfig run into error."
				exit 1
			fi

		else

			log_message "ERROR" "Failed to change grub boottime, grub2-mkconfig not present."

		fi

	fi
}

system_refresh() {

    log_message "REFRESH" "Refreshing repositories..."

    sudo zypper ref

    if test $? -eq 0; then
	    log_message "SUCCESS" "Refreshing repositories..."
    else
	    log_message "ERROR" "Failed to refresh repositories"
	    exit 1
    fi

}

system_update() {

    # Detect openSUSE variant
    if [ -f /etc/os-release ]; then

	    source /etc/os-release

	    if test $? -eq 0; then
		    log_message "INFO" "Detected: '""$PRETTY_NAME""'"
	    else
		    log_message "ERROR" "Failed to detect openSUSE version"
		    exit 1
	    fi

    fi

    # Only run dist-upgrade (dup) on Slowroll or Tumbleweed

    log_message "UPDATE" "Updating system..."

    if echo "$ID" | grep -qiE 'tumbleweed|slowroll'; then

	    sudo zypper --non-interactive dup

	    if test $? -eq 0; then
		    log_message "SUCCESS" "Distro-Updating system..."
	    else
		    log_message "ERROR" "Failed to update '""$ID""'"
		    exit 1
	    fi

    else

	    sudo zypper --non-interactive up

	    if test $? -eq 0; then
		    log_message "SUCCESS" "Updating system..."
	    else
		    log_message "ERROR" "Failed to update '""$ID""'"
		    exit 1
	    fi

    fi

}

system_reboot() {

    # Reboot system if required
    if [ -x /usr/bin/needs-restarting ]; then

	    needs-restarting -r

	    if test $? -eq 0; then
		    log_message "REBOOT" "Rebooting system..."
		    sudo systemctl reboot || log_message "ERROR" "Rebooting system"
	    else
		    log_message "SKIPPING" "Reboot not required; skipping reboot"
	    fi

    fi

}

create_snapshot() {

	# varable
	local TYPE="$1"

	# process
	if [[ "$TYPE" == "pre" ]]; then

		log_message "SNAPSHOT" "Creating pre-installation snapshot..."

		sudo snapper create -d "PRE-installation SNAPSHOT"

		if test $? -eq 0; then
			log_message "INFO" "Pre-installation snapshot created."
		else
			log_message "ERROR" "Failed to create pre-installation snapshot."
			exit 1
		fi

	elif [[ "$TYPE" == "post" ]]; then

		log_message "SNAPSHOT" "Creating post-installation snapshot..."

		sudo snapper create -d "POST-installation SNAPSHOT"

		if test $? -eq 0; then
			log_message "INFO" "POST-installation snapshot created."
		else
			log_message "ERROR" "Failed to create POST-installation snapshot."
			exit 1
		fi

	else

		log_message "ERROR" "Failed to create ANY-installation snapshot."
		exit 1

	fi
}

create_pre_snapshot() {

	PRE_ID=$(sudo snapper create --type pre --print-number --description "Start initial installation")

	if test $? -eq 0; then
		log_message "INFO" "PRE-snapshot $PRE_ID created successfully"
	else
		log_message "ERROR" "Error creating PRE-snapshot"
		exit 1
	fi

}

create_post_snapshot() {

	POST_ID=$(sudo snapper create --type post --pre-number "$PRE_ID" --print-number --description "End initial installation")

	if test $? -eq 0; then
		log_message "INFO" "POST snapshot $POST_ID created successfully and linked to PRE-snapshot $PRE_ID"
	else
		log_message "ERROR" "Error creating POST-snapshot"
		exit 1
	fi

}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Repositories ~~~~~~~~~~~~~~~~~~~~~~~~~~

add_repo_vscodium() {

    # add gitlab.com_paulcarroty_vscodium_repo repo if not already installed
    # from: https://vscodium.com/

    if zypper lr | grep -q "gitlab.com_paulcarroty_vscodium_repo"; then
        log_message "INFO" "Repository gitlab.com_paulcarroty_vscodium_repo already exists."
    else
        log_message "ADDING" "Adding repository gitlab.com_paulcarroty_vscodium_repo"
        sudo tee -a /etc/zypp/repos.d/vscodium.repo << 'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
    fi

}

add_repo_utilities() {

    if check_leap; then
        if zypper lr | grep -q "utilities"; then
            log_message "INFO" "Repository utilities already exists."
        else
            log_message "ADDING" "Adding repository utilities"
            sudo zypper addrepo -cfp 95 'https://download.opensuse.org/repositories/utilities/$releasever/' utilities || log_message "ERROR" "Failed to update repository utilities."
        fi
    fi

    if check_slowroll; then
        if zypper lr | grep -q "utilities"; then
            log_message "INFO" "Repository utilities already exists."
        else
            log_message "ADDING" "Adding repository utilities"
            #sudo zypper addrepo -cfp 95 'https://download.opensuse.org/repositories/utilities/$releasever/' utilities || log_message "ERROR" "Failed to update repository utilities."
        fi
    fi

    if check_tumbleweed; then
        if zypper lr | grep -q "utilities"; then
            log_message "INFO" "Repository utilities already exists."
        else
            log_message "ADDING" "Adding repository utilities"
            #sudo zypper addrepo -cfp 95 'https://download.opensuse.org/repositories/utilities/$releasever/' utilities || log_message "ERROR" "Failed to update repository utilities."
        fi
    fi

}

add_repo_packman() {

    if check_leap; then
        if zypper lr | grep -q "packman"; then
            log_message "INFO" "Repository packman already exists."
        else
            log_message "ADDING" "Adding repository packman"
            sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman || log_message "ERROR" "Failed to update repository packman-essentials."
        fi
    fi

    if check_slowroll; then
        if zypper lr | grep -q "packman"; then
            log_message "INFO" "Repository packman already exists."
        else
            log_message "ADDING" "Adding repository packman"
            sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Slowroll/' packman || log_message "ERROR" "Failed to update repository packman-essentials."
        fi
    fi

    if check_tumbleweed; then
        if zypper lr | grep -q "packman"; then
            log_message "INFO" "Repository packman already exists."
        else
            log_message "ADDING" "Adding repository packman"
            sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman || log_message "ERROR" "Failed to update repository packman-essentials."
        fi
    fi

}

add_repo_packman_essentials() {

    if check_leap; then
        if zypper lr | grep -q "packman-essentials"; then
            log_message "INFO" "Repository packman-essentials already exists."
        else
            log_message "ADDING" "Adding repository packman-essentials"
            sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/Essentials' packman-essentials || log_message "ERROR" "Failed to update repository packman-essentials."
        fi
    fi

    if check_slowroll; then
        if zypper lr | grep -q "packman-essentials"; then
            log_message "INFO" "Repository packman-essentials already exists."
        else
            log_message "ADDING" "Adding repository packman-essentials"
            sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Slowroll/Essentials' packman-essentials || log_message "ERROR" "Failed to update repository packman-essentials."
        fi
    fi

    if check_tumbleweed; then
        if zypper lr | grep -q "packman-essentials"; then
            log_message "INFO" "Repository packman-essentials already exists."
        else
            log_message "ADDING" "Adding repository packman-essentials"
            sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/' packman-essentials || log_message "ERROR" "Failed to update repository packman-essentials."
        fi
    fi

}

add_repo_flathub_system() {
    # install the flathub repository if not already installed
    if flatpak remote-list --system | grep -q "flathub"; then
        log_message "INFO" "Flathub repository is already installed, skipping."
    else
        log_message "INFO" "Installing Flathub repository..."
        flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && log_message "INFO" "Flathub repository installed." || log_message "ERROR" "Failed to install Flathub repository."
    fi
    
}

add_repo_flathub_user() {

    # install the flathub repository if not already installed
    if flatpak remote-list --user | grep -q "flathub"; then
        log_message "INFO" "Flathub repository is already installed, skipping."
    else
        log_message "INFO" "Installing Flathub repository..."
        flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && log_message "INFO" "Flathub repository installed." || log_message "ERROR" "Failed to install Flathub repository."
    fi

}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Apps ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Check if package is installed on OpenSUSE
app_exists() {
	command -v "$1" >/dev/null 2>&1 || rpm -q "$1" >/dev/null 2>&1
}

repo_exists() {
	zypper lr | grep -q "$1" >/dev/null 2>&1
}

install_app() {
	local APP="${1:?Error: Required parameter missing}"
	local REPO="${2-}" # expand to empty if unset (safe under -u)

	line_blue

	if [[ -z "$APP" ]]; then
		text_color "Red" "No parameter 1 passed."
		return 1
	else
		text_color "Cyan" "Installing $APP"
	fi

	if ! [[ -n "$REPO" ]]; then
		REPO="default"
	fi

	text_color "Cyan" "from repository $REPO"

	line_blue

	# when an app is provided, but no repo (use default repo)
	if [[ "$REPO" == "default" ]]; then

		if app_exists "$APP"; then
			log_message "INFO" "$APP is already installed, skipping installation."
		else
			log_message "INFO" "Installing $APP from the default repository."
			sudo zypper --non-interactive install "$APP"

			if test $? -eq 0; then
				log_message "INSTALL" "$APP installed successfully."
			else
				log_message "ERROR" "Failed to install $APP."
				exit 1
			fi
		fi

	else

		# when an app and a repo is provided (use specific repo with vendor change for the app, if repo not present use default repo)
		if repo_exists "$REPO"; then

			if app_exists "$APP"; then
				log_message "INFO" "$APP is already installed, skipping installation."
			else
				log_message "INFO" "Installing $APP from repository $REPO."
				sudo zypper --non-interactive install --allow-vendor-change --from "$REPO" "$APP"

				if test $? -eq 0; then
					log_message "INSTALL" "$APP installed successfully."
				else
					log_message "ERROR" "Failed to install $APP from $REPO."
					exit 1
				fi
			fi
		else

			log_message "INFO" "Provided repository $REPO is not present. Diverting to default repository for $APP."

			if app_exists "$APP"; then
				log_message "INFO" "$APP is already installed, skipping installation."
			else
				log_message "INFO" "Installing $APP from default repo."
				sudo zypper --non-interactive install "$APP"

				if test $? -eq 0; then
					log_message "INSTALL" "$APP installed successfully."
				else
					log_message "ERROR" "Failed to install $APP."
					exit 1
				fi
			fi
		fi
	fi
}

install_app_interactive() {
	APP="$1"
	REPO="${2:-""}"

	# when an app is provided, but no repo (use default repo)
	if [[ -n "$1" ]] && [[ -z "${2:-""}" ]]; then
		if app_exists "$APP"; then
			log_message "INFO" "$APP is already installed, skipping installation."
		else
			log_message "INFO" "Installing $APP..."
			sudo zypper install "$APP"

			if test $? -eq 0; then
				log_message "INSTALL" "$APP installed successfully."
			else
				log_message "ERROR" "Failed to install $APP."
				exit 1
			fi
		fi
	fi

	# when an app and a repo is provided (use specific repo with vendor change for the app, if repo not present use default repo)
	if [[ -n "$1" ]] && [[ -n "${2:-""}" ]]; then
		if repo_exists "$REPO"; then
			log_message "INFO" "Installing $APP from $REPO..."
			sudo zypper install --allow-vendor-change --from "$REPO" "$APP"

			if test $? -eq 0; then
				log_message "INSTALL" "$APP installed successfully."
			else
				log_message "ERROR" "Failed to install $APP from $REPO."
				exit 1
			fi
		else
			log_message "INFO" "Installing $APP from default repo. Repository $REPO not present."
			sudo zypper install "$APP"

			if test $? -eq 0; then
				log_message "INSTALL" "$APP installed successfully."
			else
				log_message "ERROR" "Failed to install $APP."
				exit 1
			fi
		fi
	fi
}

remove_app() {
	APP="$1"

	if app_exists "$APP"; then
		log_message "INFO" "Removing $APP..."
		sudo zypper remove -y "$APP"

		if test $? -eq 0; then
			log_message "REMOVE" "$APP removed successfully."
		else
			og_message "ERROR" "Failed to remove $APP."
			exit 1
		fi
	else
		log_message "INFO" "$APP is not installed, skipping removal."
	fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Flatpaks ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Check if flatpak is installed on OpenSUSE
flatpak_exists() {
	flatpak list | grep "$1" >/dev/null 2>&1
}

install_flatpak_system() {
	APP="$1"

	if flatpak list --app | grep -q "$APP"; then
		log_message "INFO" "$APP is already installed, skipping installation."
	else
		log_message "INFO" "Installing $APP..."
		flatpak install --system -y flathub "$APP"

		if test $? -eq 0; then
			log_message "INSTALL" "$APP installed successfully."
		else
			log_message "ERROR" "Failed to install $APP."
			exit 1
		fi
	fi
}

install_flatpak_user() {
	APP="$1"

	if flatpak list --app | grep -q "$APP"; then
		log_message "INFO" "$APP is already installed, skipping installation."
	else
		log_message "INFO" "Installing $APP..."
		flatpak install --user -y flathub "$APP"

		if test $? -eq 0; then
			log_message "INSTALL" "$APP installed successfully."
		else
			log_message "ERROR" "Failed to install $APP."
			exit 1
		fi
	fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~