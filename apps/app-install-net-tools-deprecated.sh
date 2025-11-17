#!/usr/bin/env bash
set -euo pipefail  # Safe bash scripting: exit on error, unset var, or pipe fail


# -----------------------------------
# installing an application
# -----------------------------------

install_app "net-tools-deprecated"

# replaces:
# arp -> ip [-r] neigh
# ifconfig -> ip a
# netstat -> ss [-r]
# route -> ip r
# needed in current aliases

# -----------------------------------
# required configuration
# -----------------------------------

# enter here