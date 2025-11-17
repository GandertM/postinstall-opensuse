#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail


# -----------------------------------
# adding repository
# -----------------------------------

# add utilities
log_message "ADDING" "Adding repository utilities"
sudo zypper addrepo -cfp 95 'https://download.opensuse.org/repositories/utilities/$releasever/' utilities || log_message "ERROR" "Failed to update repository utilities."
