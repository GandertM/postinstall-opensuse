#!/usr/bin/env bash
set -euo pipefail # Safe bash scripting: exit on error, unset var, or pipe fail

# -----------------------------------
# installation
# -----------------------------------

install_app "autofs"

# -----------------------------------
# configuration
# -----------------------------------

sudo cp /etc/auto.master /etc/auto.master.bak

sudo tee -a /etc/auto.master <<'EOF'
#
# Added by postinstall
/mnt/nas /etc/auto.nas --timeout=20 --ghost
EOF

sudo tee -a /etc/auto.nas <<'EOF'
#
# Added by postinstall
backup          -fstype=nfs,nofail,_netdev,defaults 10.10.30.20:/volume1/backup
dl-diskst       -fstype=nfs,nofail,_netdev,defaults 10.10.30.20:/volume1/downloads
film            -fstype=nfs,nofail,_netdev,defaults 10.10.30.20:/volume1/film
foto            -fstype=nfs,nofail,_netdev,defaults 10.10.30.20:/volume1/foto
gedeeld         -fstype=nfs,nofail,_netdev,defaults 10.10.30.20:/volume1/gedeeld
kluis           -fstype=nfs,nofail,_netdev,defaults 10.10.30.20:/volume1/kluis
muziek          -fstype=nfs,nofail,_netdev,defaults 10.10.30.20:/volume1/muziek
muziekarchief   -fstype=nfs,nofail,_netdev,defaults 10.10.30.20:/volume1/muziekarchief
EOF

# -----------------------------------
# start service
# -----------------------------------

sudo systemctl enable --now autofs.service || log_message "ERROR" "Failed to enable autofs"
