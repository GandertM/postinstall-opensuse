#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail


# -----------------------------------
# adding repository
# -----------------------------------

# add packman-essentials repo if not already installed

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
        #sudo zypper addrepo -cfp 81 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Slowroll/Essentials' packman-essentials || log_message "ERROR" "Failed to update repository packman-essentials."
    fi
fi

if check_tumbleweed; then
    if zypper lr | grep -q "packman-essentials"; then
        log_message "INFO" "Repository packman-essentials already exists."
    else
        log_message "ADDING" "Adding repository packman-essentials"
        #sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/Essentials' packman-essentials || log_message "ERROR" "Failed to update repository packman-essentials."
    fi
fi