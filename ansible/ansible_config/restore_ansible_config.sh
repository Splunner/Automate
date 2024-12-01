#!/bin/bash

# Check if script is run with sudo
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run with sudo."
  exit 1
fi

# Get the username of the user who executed sudo
SUDO_USER=$(logname)

# Prompt for input and output paths
read -p "Enter the full path to ansible.cfg: " INPUT_PATH
OUTPUT_DIR="/etc/ansible"
OUTPUT_FILE="$OUTPUT_DIR/ansible.cfg"

# Check if input file exists
if [ ! -f "$INPUT_PATH" ]; then
  echo "Error: File not found at $INPUT_PATH"
  exit 1
fi

# Create a backup with a timestamp if ansible.cfg already exists in /etc
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$OUTPUT_DIR/ansible.cfg.backup_$TIMESTAMP"
if [ -f "$OUTPUT_FILE" ]; then
  cp "$OUTPUT_FILE" "$BACKUP_FILE"
  echo "Backup created at $BACKUP_FILE"
fi

# Copy the file to /etc
cp "$INPUT_PATH" "$OUTPUT_FILE"
echo "File copied to $OUTPUT_FILE"

# Set ownership to the sudo user and restrict permissions
chown "$SUDO_USER":"$SUDO_USER" "$OUTPUT_FILE"
chmod 700 "$OUTPUT_FILE"

echo "Ownership set to $SUDO_USER and permissions restricted (only the user can execute)."
