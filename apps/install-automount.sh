#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~ HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# install-automount.sh
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ NFS configuration ~~~~~~~~~~~~~~~~~~~~~~~~~~

# common variables
BASE_MOUNT_DESCR="NFS mount -"             # for mount unit 
BASE_AUTOMOUNT_DESCR="NFS automount -"     # for automount unit 
BASE_LOCATION="/mnt"                       # default base location
BASE_SERVER="10.10.30.20:/volume1"         # default server location
BASE_SYSTEMD="/etc/systemd/system"         # default location for units

# arrays
SHARES=("backup" "downloads" "film" "foto" "gedeeld" "kluis" "muziek" "muziekarchief")

# --------------------------
# mount units
# --------------------------

for SHARE in "${SHARES[@]}"; do
    
    # set variables
    VUNIT_NAME="${BASE_LOCATION:1}-$SHARE.mount"
    VDESCR="$BASE_MOUNT_DESCR $SHARE"
    VWHAT="$BASE_SERVER/$SHARE"
    VWHERE="$BASE_LOCATION/$SHARE"
    
    if [[ -f "$BASE_SYSTEMD/$VUNIT_NAME" ]]; then
        
        log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME already exists. Skipping."
        
    else
        # create
        
        sudo tee -a "$BASE_SYSTEMD/$VUNIT_NAME" << EOF
[Unit]
Description = $VDESCR

[Mount]
What=$VWHAT
Where=$VWHERE
Type=nfs
Options=nofail,_netdev,defaults
TimeoutSec=5

[Install]
WantedBy=multi-user.target
EOF
   
        log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME created."

    fi

done

# --------------------------
# automount units
# --------------------------

for SHARE in "${SHARES[@]}"; do
    
    # set variables
    VUNIT_NAME="${BASE_LOCATION:1}-$SHARE.automount"
    VDESCR="$BASE_AUTOMOUNT_DESCR $SHARE"
    #VWHAT="$BASE_SERVER/$SHARE"
    VWHERE="$BASE_LOCATION/$SHARE"
    
    if [[ -f "$BASE_SYSTEMD/$VUNIT_NAME" ]]; then
        
        log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME already exists. Skipping."
        
    else
        # create
        
        sudo tee -a "$BASE_SYSTEMD/$VUNIT_NAME" << EOF
[Unit]
Description = $VDESCR

[Automount]
Where=$VWHERE
TimeoutIdleSec=15

[Install]
WantedBy=multi-user.target
EOF
   
        log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME created."

    fi

    # start unit
    sudo systemctl enable --now "$VUNIT_NAME" || log_message "ERROR" "Failed to enable automount $VUNIT_NAME."

done


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ NFS configuration HOME ~~~~~~~~~~~~~~~~~~~~~~~~~~

# --------------------------
# mount HOME
# --------------------------

# set variables
VUNIT_NAME="${BASE_LOCATION:1}-homenas.mount"
VDESCR="$BASE_MOUNT_DESCR homenas"
VWHAT="$BASE_SERVER/homes/$USER"
VWHERE="$BASE_LOCATION/homenas"
    
if [[ -f "$BASE_SYSTEMD/$VUNIT_NAME" ]]; then
        
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME already exists. Skipping."
        
else
    # create
        
    sudo tee -a "$BASE_SYSTEMD/$VUNIT_NAME" << EOF
[Unit]
Description = $VDESCR

[Mount]
What=$VWHAT
Where=$VWHERE
Type=nfs
Options=nofail,_netdev,defaults
TimeoutSec=5

[Install]
WantedBy=multi-user.target
EOF
   
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME created."

fi

# --------------------------
# automount HOME
# --------------------------

# set variables
VUNIT_NAME="${BASE_LOCATION:1}-homenas.automount"
VDESCR="$BASE_AUTOMOUNT_DESCR homenas"
#VWHAT="$BASE_SERVER/$SHARE"
VWHERE="$BASE_LOCATION/homenas"
    
if [[ -f "$BASE_SYSTEMD/$VUNIT_NAME" ]]; then
        
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME already exists. Skipping."
        
else
    # create
        
    sudo tee -a "$BASE_SYSTEMD/$VUNIT_NAME" << EOF
[Unit]
Description = $VDESCR

[Automount]
Where=$VWHERE
TimeoutIdleSec=15

[Install]
WantedBy=multi-user.target
EOF
   
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME created."

fi

# start unit
sudo systemctl enable --now "$VUNIT_NAME" || log_message "ERROR" "Failed to enable automount $VUNIT_NAME."


# ~~~~~~~~~~~~~~~~~~~~~~~~~~ SAMBA configuration ~~~~~~~~~~~~~~~~~~~~~~~~~~

# common variables
BASE_MOUNT_DESCR="CIFS mount -"            # for mount unit 
BASE_AUTOMOUNT_DESCR="CIFS automount -"    # for automount unit 
BASE_LOCATION="/mnt"                       # default base location
BASE_SERVER="10.10.30.20:/volume1"         # default server location
BASE_SYSTEMD="/etc/systemd/system"         # default location for units

# --------------------------
# mount HOMEWRK
# --------------------------

# set variables
VUNIT_NAME="${BASE_LOCATION:1}-homewrk.mount"
VDESCR="$BASE_MOUNT_DESCR homewrk"
VWHERE="$BASE_LOCATION/homewrk"
    
if [[ -f "$BASE_SYSTEMD/$VUNIT_NAME" ]]; then
        
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME already exists. Skipping."
        
else
    # create
        
    sudo tee -a "$BASE_SYSTEMD/$VUNIT_NAME" << EOF
[Unit]
Description = $VDESCR

[Mount]
What=//10.10.30.20/home
Where=$VWHERE
Type=cifs
Options=nofail,_netdev,credentials=/home/$USER/.crd/smbwrk.crd,workgroup=WORKGROUP,iocharset=utf8,vers=3.0,uid=1027,gid=1027
TimeoutSec=5

[Install]
WantedBy=multi-user.target
EOF
   
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME created."

fi

# --------------------------
# automount HOMEWRK
# --------------------------

# set variables
VUNIT_NAME="${BASE_LOCATION:1}-homewrk.automount"
VDESCR="$BASE_AUTOMOUNT_DESCR homewrk"
VWHERE="$BASE_LOCATION/homewrk"
    
if [[ -f "$BASE_SYSTEMD/$VUNIT_NAME" ]]; then
        
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME already exists. Skipping."
        
else
    # create
        
    sudo tee -a "$BASE_SYSTEMD/$VUNIT_NAME" << EOF
[Unit]
Description = $VDESCR

[Automount]
Where=$VWHERE
TimeoutIdleSec=15

[Install]
WantedBy=multi-user.target
EOF
   
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME created."

fi

# start unit
sudo systemctl enable --now "$VUNIT_NAME" || log_message "ERROR" "Failed to enable automount $VUNIT_NAME."

# --------------------------
# mount HOMEWRKOLD
# --------------------------

# set variables
VUNIT_NAME="${BASE_LOCATION:1}-homewrk.mount"
VDESCR="$BASE_MOUNT_DESCR homewrk"
VWHERE="$BASE_LOCATION/homewrk"
    
if [[ -f "$BASE_SYSTEMD/$VUNIT_NAME" ]]; then
        
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME already exists. Skipping."
        
else
    # create
        
    sudo tee -a "$BASE_SYSTEMD/$VUNIT_NAME" << EOF
[Unit]
Description = $VDESCR

[Mount]
What=//10.10.30.20/home
Where=$VWHERE
Type=cifs
Options=nofail,_netdev,credentials=/home/$USER/.crd/smbwrkold.crd,workgroup=WORKGROUP,iocharset=utf8,vers=3.0,uid=1027,gid=1027
TimeoutSec=5

[Install]
WantedBy=multi-user.target
EOF
   
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME created."

fi

# --------------------------
# automount HOMEWRKOLD
# --------------------------

# set variables
VUNIT_NAME="${BASE_LOCATION:1}-homewrk.automount"
VDESCR="$BASE_AUTOMOUNT_DESCR homewrk"
VWHERE="$BASE_LOCATION/homewrk"
    
if [[ -f "$BASE_SYSTEMD/$VUNIT_NAME" ]]; then
        
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME already exists. Skipping."
        
else
    # create
        
    sudo tee -a "$BASE_SYSTEMD/$VUNIT_NAME" << EOF
[Unit]
Description = $VDESCR

[Automount]
Where=$VWHERE
TimeoutIdleSec=15

[Install]
WantedBy=multi-user.target
EOF
   
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME created."

fi

# start unit
sudo systemctl enable --now "$VUNIT_NAME" || log_message "ERROR" "Failed to enable automount $VUNIT_NAME."

# --------------------------
# mount DWNLDSBS
# --------------------------

# set variables
VUNIT_NAME="${BASE_LOCATION:1}-dwnldsbs.mount"
VDESCR="$BASE_MOUNT_DESCR dwnldsbs"
VWHERE="$BASE_LOCATION/dwnldsbs"
    
if [[ -f "$BASE_SYSTEMD/$VUNIT_NAME" ]]; then
        
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME already exists. Skipping."
        
else
    # create
        
    sudo tee -a "$BASE_SYSTEMD/$VUNIT_NAME" << EOF
[Unit]
Description = $VDESCR

[Mount]
What=//10.10.30.21/downloads
Where=$VWHERE
Type=cifs
Options=nofail,_netdev,credentials=/home/$USER/.crd/smbdwl.crd,workgroup=WORKGROUP,iocharset=utf8,vers=3.0,uid=1027,gid=1027
TimeoutSec=5

[Install]
WantedBy=multi-user.target
EOF
   
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME created."

fi

# --------------------------
# automount DWNLDSBS
# --------------------------

# set variables
VUNIT_NAME="${BASE_LOCATION:1}-dwnldsbs.automount"
VDESCR="$BASE_AUTOMOUNT_DESCR dwnldsbs"
VWHERE="$BASE_LOCATION/dwnldsbs"
    
if [[ -f "$BASE_SYSTEMD/$VUNIT_NAME" ]]; then
        
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME already exists. Skipping."
        
else
    # create
        
    sudo tee -a "$BASE_SYSTEMD/$VUNIT_NAME" << EOF
[Unit]
Description = $VDESCR

[Automount]
Where=$VWHERE
TimeoutIdleSec=15

[Install]
WantedBy=multi-user.target
EOF
   
    log_message "INFO" "File $BASE_SYSTEMD/$VUNIT_NAME created."

fi

# start unit
sudo systemctl enable --now "$VUNIT_NAME" || log_message "ERROR" "Failed to enable automount $VUNIT_NAME."



# ~~~~~~~~~~~~~~~~~~~~~~~~~~ End ~~~~~~~~~~~~~~~~~~~~~~~~~~
