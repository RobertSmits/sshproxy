#!/bin/bash

. /etc/profile

# Configuration for the MODERN server
DEST_IP=$SSH_HOST
DEST_PORT=$SSH_PORT
DEST_USER=$SSH_USER
DEST_PASS=$SSH_PASSWORD

# Debugging: If any critical variable is empty, print an error instead of failing silently
if [ -z "$DEST_IP" ] || [ -z "$DEST_USER" ]; then
    echo "ERROR: Bridge configuration missing!"
    echo "HOST: $DEST_IP | USER: $DEST_USER | PORT: $DEST_PORT"
    exit 1
fi

# Execute the modern SSH connection
# -o StrictHostKeyChecking=no prevents the script from hanging on 'Accept host key?'
exec sshpass -p "$DEST_PASS" ssh -o StrictHostKeyChecking=no "$DEST_USER@$DEST_IP" -p$DEST_PORT
