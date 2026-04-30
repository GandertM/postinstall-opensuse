#!/usr/bin/env bash
#
# system-function-users.sh
#

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Bash ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Safe bash scripting 
set -euo pipefail       # exit on error, unset var, or pipe fail


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ Logging ~~~~~~~~~~~~~~~~~~~~~~~~~~

# Function to add users
add_user() {

	# Ensure script is run as root
	if [[ "$(id -u)" -ne 0 ]]; then
		printf 'This script must be run as root.\n' >&2
		exit 1
	fi

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
		useradd -m -u "$ID" -c "$comment" "$username"

        if test $? -eq 0; then
		    log_message "INFO" "Function sourced successfully"
	    else
		    log_message "ERROR" "Error sourcing functions"
		    exit 1
	    fi

	else
		useradd -m -c "$comment" "$username"
	fi

    if test $? -eq 0; then
	    log_message "INFO" "Adding user $username successfully"
    else
	    log_message "ERROR" "Error adding user $username"
	    exit 1
    fi

	# Set the password
	printf '%s:%s\n' "$username" "$password" | chpasswd

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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~