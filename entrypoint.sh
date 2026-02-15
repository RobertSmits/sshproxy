#!/bin/bash

# Update port (default to 22 if SSH_PORT is not set)
PORT=${SSH_PORT:-22}
sed -i "s/^#\?Port .*/Port $PORT/" /etc/ssh/sshd_config

# Check for required variables
if [ -z "$SSH_USER" ] || [ -z "$SSH_PASSWORD" ]; then
    echo "ERROR: SSH_USER or SSH_PASSWORD not set!"
    exit 1
fi

# Create the user and set password
adduser -D -s /usr/local/bin/bridge.sh "$SSH_USER"
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd

# Persist environment for the bridge script
env | grep SSH_ > /etc/profile.d/bridge_env.sh
sed -i "s/^/export /" /etc/profile.d/bridge_env.sh

echo "Starting sshd on port $PORT..."
exec /usr/sbin/sshd -D -e