#!/usr/bin/env bash
set -euo pipefail # Safe bash scripting: exit on error, unset var, or pipe fail

# Function to log messages
log_message() {
	LEVEL=$1
	MESSAGE=$2
	NOW=$(date '+%Y-%m-%d %H:%M:%S')
	printf "%s | %-8s | %s\n" "$NOW" "$LEVEL" "$MESSAGE" >>"$LOGFILE"
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
	#APP="$1"
	#REPO="${2:-""}"

	if [[ -z $1 ]]; then
		echo "No parameter passed."
		return
	else
		echo "Parameter passed = $1"
		local APP="$1"
	fi

	if [[ -z $2 ]]; then
		echo "No parameter passed."
		local REPO="default"
	else
		echo "Parameter passed = $2"
		local REPO="$2"
	fi

	# when an app is provided, but no repo (use default repo)
	#if [[ -n "$1" ]] && [[ -z "${2:-""}" ]]; then
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

	#fi
	else

		# when an app and a repo is provided (use specific repo with vendor change for the app, if repo not present use default repo)
		#if [[ -n "$1" ]] && [[ -n "${2:-""}" ]]; then

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
