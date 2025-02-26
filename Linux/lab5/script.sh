#!/bin/bash

# Variables
REMOTE_USER="ivolve"
REMOTE_HOST="192.168.74.135"
ALIAS_NAME="ivolve"
SSH_DIR="$HOME/.ssh"
CONFIG_FILE="$SSH_DIR/config"

# Generate SSH keys
ssh-keygen -t rsa -b 2048 -f "$SSH_DIR/id_rsa" -N ""

# Copy the public key to the remote VM
ssh-copy-id -i "$SSH_DIR/id_rsa.pub" "$REMOTE_USER@$REMOTE_HOST"

# Configure SSH to use the alias
{
    echo "Host $ALIAS_NAME"
    echo "    HostName $REMOTE_HOST"
    echo "    User $REMOTE_USER"
    echo "    IdentityFile $SSH_DIR/id_rsa"
} >> "$CONFIG_FILE"

echo "SSH configuration completed. You can now connect using 'ssh $ALIAS_NAME'."