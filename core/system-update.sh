#!/usr/bin/env bash
set -euo pipefail # Safe bash scripting: exit on error, unset var, or pipe fail

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
