#!/usr/bin/env bash
set -euo pipefail # Safe bash scripting: exit on error, unset var, or pipe fail

# -----------------------------------
# adding repository
# -----------------------------------

# add gitlab.com_paulcarroty_vscodium_repo repo if not already installed
# from: https://vscodium.com/

if check_leap; then
	if zypper lr | grep -q "gitlab.com_paulcarroty_vscodium_repo"; then
		log_message "INFO" "Repository gitlab.com_paulcarroty_vscodium_repo already exists."
	else
		log_message "ADDING" "Adding repository gitlab.com_paulcarroty_vscodium_repo"
		sudo tee -a /etc/zypp/repos.d/vscodium.repo <<'EOF'
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
fi

if check_slowroll; then
	if zypper lr | grep -q "gitlab.com_paulcarroty_vscodium_repo"; then
		log_message "INFO" "Repository gitlab.com_paulcarroty_vscodium_repo already exists."
	else
		log_message "ADDING" "Adding repository gitlab.com_paulcarroty_vscodium_repo"
		sudo tee -a /etc/zypp/repos.d/vscodium.repo <<'EOF'
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
fi

if check_tumbleweed; then
	if zypper lr | grep -q "gitlab.com_paulcarroty_vscodium_repo"; then
		log_message "INFO" "Repository gitlab.com_paulcarroty_vscodium_repo already exists."
	else
		log_message "ADDING" "Adding repository gitlab.com_paulcarroty_vscodium_repo"
		sudo tee -a /etc/zypp/repos.d/vscodium.repo <<'EOF'
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
fi
