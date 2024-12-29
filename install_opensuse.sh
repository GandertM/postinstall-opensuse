#!/bin/bash

# Check if the user has sudo rights
if ! sudo -v &>/dev/null; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR User does not have sudo rights"
  exit 1
fi

# Create a timestamp for the log file name
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
LOGFILE="install_${TIMESTAMP}.log"

# Function to log messages
log_message() {
  LEVEL=$1
  MESSAGE=$2
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$LEVEL] $MESSAGE" >> "$LOGFILE"
}

# Create a pre-installation snapshot with snapper
log_message "INFO" "Creating pre-installation snapshot..."
sudo snapper create -d "Pre-installation snapshot" || log_message "ERROR" "Failed to create pre-installation snapshot"

# Update repositories
log_message "INFO" "Updating repositories..."
sudo zypper refresh || log_message "ERROR" "Failed to update repositories"

# System update
log_message "INFO" "Performing system update..."
sudo zypper update -y || log_message "ERROR" "Failed to update system"

# Check if package is installed
app_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a program is installed on OpenSUSE
is_opensuse_package_installed() {
    local package="$1"
    #app_exists "$package" > /dev/null 2>&1  # error on micro-editor; will reinstall
    rpm -q "$package" > /dev/null 2>&1 # doesn't not work
}

# Install applications listed in apps2install.lst
if [[ -f "apps2install.lst" ]]; then
  while IFS= read -r app || [[ -n "$app" ]]; do
    # Ignore comments and empty lines
    if [[ "$app" =~ ^\s*# ]] || [[ -z "$app" ]]; then
      continue
    fi

    apps=($app)  # Split the line by spaces into an array
    for app_name in "${apps[@]}"; do
      #if zypper se -i "$app_name" &>/dev/null; then
      if is_opensuse_package_installed "$app_name"; then
        log_message "INFO" "$app_name is already installed, skipping installation."
      else
        log_message "INFO" "Installing $app_name..."
        sudo zypper install -y "$app_name" && log_message "INFO" "$app_name installed successfully." || log_message "ERROR" "Failed to install $app_name."
      fi
    done
  done < "apps2install.lst"
else
  log_message "INFO" "No apps2install.lst file found."
fi

# Remove applications listed in apps2remove.lst
if [[ -f "apps2remove.lst" ]]; then
  while IFS= read -r app || [[ -n "$app" ]]; do
    # Ignore comments and empty lines
    if [[ "$app" =~ ^\s*# ]] || [[ -z "$app" ]]; then
      continue
    fi

    apps=($app)  # Split the line by spaces into an array
    for app_name in "${apps[@]}"; do
      #if zypper se -i "$app_name" &>/dev/null; then
      if is_opensuse_package_installed "$app_name"; then
        log_message "INFO" "Removing $app_name..."
        sudo zypper remove -y "$app_name" && log_message "INFO" "$app_name removed successfully." || log_message "ERROR" "Failed to remove $app_name."
      else
        log_message "INFO" "$app_name is not installed, skipping removal."
      fi
    done
  done < "apps2remove.lst"
else
  log_message "INFO" "No apps2remove.lst file found."
fi

# Install the Flathub repository if not already installed
log_message "INFO" "Checking for Flathub repository..."
if flatpak remote-list | grep -q "flathub"; then
  log_message "INFO" "Flathub repository is already installed, skipping."
else
  log_message "INFO" "Installing Flathub repository..."
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && log_message "INFO" "Flathub repository installed." || log_message "ERROR" "Failed to install Flathub repository."
fi

# Install flatpaks listed in flatpaks2install.lst
if [[ -f "flatpaks2install.lst" ]]; then
  while IFS= read -r flatpak || [[ -n "$flatpak" ]]; do
    # Ignore comments and empty lines
    if [[ "$flatpak" =~ ^\s*# ]] || [[ -z "$flatpak" ]]; then
      continue
    fi

    flatpaks=($flatpak)  # Split the line by spaces into an array
    for flatpak_name in "${flatpaks[@]}"; do
      if flatpak list --app | grep -q "$flatpak_name"; then
        log_message "INFO" "$flatpak_name is already installed, skipping installation."
      else
        log_message "INFO" "Installing $flatpak_name..."
        flatpak install --user -y flathub "$flatpak_name" && log_message "INFO" "$flatpak_name installed successfully." || log_message "ERROR" "Failed to install $flatpak_name."
      fi
    done
  done < "flatpaks2install.lst"
else
  log_message "INFO" "No flatpaks2install.lst file found."
fi

# Remove flatpaks listed in flatpaks2remove.lst
if [[ -f "flatpaks2remove.lst" ]]; then
  while IFS= read -r flatpak || [[ -n "$flatpak" ]]; do
    # Ignore comments and empty lines
    if [[ "$flatpak" =~ ^\s*# ]] || [[ -z "$flatpak" ]]; then
      continue
    fi

    flatpaks=($flatpak)  # Split the line by spaces into an array
    for flatpak_name in "${flatpaks[@]}"; do
      if flatpak list --app | grep -q "$flatpak_name"; then
        log_message "INFO" "Removing $flatpak_name..."
        flatpak uninstall -y "$flatpak_name" && log_message "INFO" "$flatpak_name removed successfully." || log_message "ERROR" "Failed to remove $flatpak_name."
      else
        log_message "INFO" "$flatpak_name is not installed, skipping removal."
      fi
    done
  done < "flatpaks2remove.lst"
else
  log_message "INFO" "No flatpaks2remove.lst file found."
fi

# Create a post-installation snapshot with snapper
log_message "INFO" "Creating post-installation snapshot..."
sudo snapper create -d "Post-installation snapshot" || log_message "ERROR" "Failed to create post-installation snapshot"

# Recommend reboot
log_message "INFO" "System installation and removals are complete. It's recommended to reboot the system."

exit 0
