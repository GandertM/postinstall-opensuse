#!/usr/bin/env bash
#
# system-function-logging.sh
#

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Packages ~~~~~~~~~~~~~~~~~~~~~~~~~~

check_leap() {
	echo "$ID" | grep -qiE 'leap'
}

check_slowroll() {
	echo "$ID" | grep -qiE 'slowroll'
}

check_tumbleweed() {
	echo "$ID" | grep -qiE 'tumbleweed'
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Packages ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Check if package is installed on OpenSUSE
app_exists() {
	command -v "$1" >/dev/null 2>&1 || rpm -q "$1" >/dev/null 2>&1
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Packages ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Check if flatpak is installed on OpenSUSE
flatpak_exists() {
	flatpak list | grep "$1" >/dev/null 2>&1
}

repo_exists() {
	zypper lr | grep -q "$1" >/dev/null 2>&1
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Packages ~~~~~~~~~~~~~~~~~~~~~~~~~~

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
