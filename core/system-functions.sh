#!/usr/bin/env bash
set -euo pipefail # Safe bash scripting: exit on error, unset var, or pipe fail

# Function to log messages
log_message() {
	LEVEL=$1
	MESSAGE=$2
	NOW=$(date '+%Y-%m-%d %H:%M:%S')
	printf "%s | %-8s | %s\n" "$NOW" "$LEVEL" "$MESSAGE" >>"$LOGFILE"
}

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
	printf "%b" "${colorString}" "$2" "${RC}\n\n"

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

check_leap() {
	echo "$ID" | grep -qiE 'leap'
}

check_slowroll() {
	echo "$ID" | grep -qiE 'slowroll'
}

check_tumbleweed() {
	echo "$ID" | grep -qiE 'tumbleweed'
}

# Check if package is installed on OpenSUSE
app_exists() {
	command -v "$1" >/dev/null 2>&1 || rpm -q "$1" >/dev/null 2>&1
}

# Check if flatpak is installed on OpenSUSE
flatpak_exists() {
	flatpak list | grep "$1" >/dev/null 2>&1
}

repo_exists() {
	zypper lr | grep -q "$1" >/dev/null 2>&1
}

install_app() {
	local APP="${1:?Error: Required parameter missing}"
	local REPO="${2-}" # expand to empty if unset (safe under -u)

	if [[ -z "$APP" ]]; then
		line_red
		text_color "Red" "No parameter 1 passed."
		line_red
		return 1
	else
		line_blue
		text_color "Cyan" "Installing $APP"
		line_blue
	fi

	if [[ -n "$REPO" ]]; then
		echo "Parameter 2 passed = $REPO"
	else
		echo "No parameter 2 passed."
		REPO="default"
	fi

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

set_grub() {

	if echo "$ID" | grep -qiE 'tumbleweed|slowroll'; then

		# change wait seconds of grub2-bls (from 8 to 2) in SLOWROLL or TUMBLEWEED
		if app_exists sdbootutil; then

			log_message "INFO" "Setting new timeout to 2 seconds"

			sudo sdbootutil set-timeout 2

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

		# change wait seconds of grub2 (from 8 to 2) in LEAP
		if [ -f /etc/default/grub ]; then

			sudo sed -i "s/GRUB_TIMEOUT=8/GRUB_TIMEOUT=2/gI" /etc/default/grub

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
