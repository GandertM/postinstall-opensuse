#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail


# -----------------------------------
# installing an application 
# from repo utilities
# usage: 1. repo 2. app
# -----------------------------------

install_app_repo "packman-essentials" "gstreamer-plugins-ugly"


# -----------------------------------
# required configuration
# -----------------------------------

# enter here