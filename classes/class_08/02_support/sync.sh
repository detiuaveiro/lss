#!/bin/bash

# Configuration
SOURCE_DIR="/data/"
REMOTE_USER="operator"
REMOTE_HOST="172.25.0.10"
REMOTE_DEST="/config/backup/"
LOG_FILE="/var/log/sync.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Check if the remote host is reachable
log_message "Checking if $REMOTE_HOST is reachable..."
if ping -c 1 -W 2 "$REMOTE_HOST" > /dev/null 2>&1; then
    log_message "Host $REMOTE_HOST is up. Starting rsync..."
    
    # Run rsync
    # Note: In a real scenario, use SSH keys for passwordless auth
    # Here we use -o StrictHostKeyChecking=no for lab convenience
    rsync -avz -e "ssh -o StrictHostKeyChecking=no" "$SOURCE_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DEST"
    
    if [ $? -eq 0 ]; then
        log_message "Synchronization completed successfully."
    else
        log_message "Error: rsync failed."
    fi
else
    log_message "Error: Host $REMOTE_HOST is unreachable. Aborting sync."
fi
