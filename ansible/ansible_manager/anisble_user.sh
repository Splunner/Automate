#!/bin/bash

# Check if the script is run as root or sudo
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root or with sudo."
  exit 1
fi

# Prompt for the username
read -p "Enter the username to create: " username

# Validate input
if [[ -z "$username" ]]; then
  echo "Username cannot be empty!"
  exit 1
fi

# Check if user exists
if id "$username" &>/dev/null; then
  echo "User '$username' already exists. No action taken."
else
  # Create the user
  useradd -m -s /bin/bash "$username" && echo "User '$username' created."

  # Add user to the appropriate group based on the distribution
  if grep -q -E "rhel|centos|oracle" /etc/os-release; then
    usermod -aG wheel "$username"
    echo "User '$username' added to the 'wheel' group (sudo permissions)."
  else
    usermod -aG sudo "$username"
    echo "User '$username' added to the 'sudo' group (sudo permissions)."
  fi
fi

# Set the user's home directory
user_home=$(eval echo ~$username)

# Function to check and create a directory
create_directory() {
  local dir_path="$1"
  local owner="$2"
  local permissions="$3"
  
  if [[ -d "$dir_path" ]]; then
    echo "Directory '$dir_path' already exists. No action taken."
  else
    mkdir -p "$dir_path" && echo "Directory '$dir_path' created."
    chown "$owner" "$dir_path" && echo "Ownership of '$dir_path' set to '$owner'."
    chmod "$permissions" "$dir_path" && echo "Permissions for '$dir_path' set to $permissions."
  fi
}

# Function to check and create a file
create_file() {
  local file_path="$1"
  local owner="$2"
  local permissions="$3"
  
  if [[ -f "$file_path" ]]; then
    echo "File '$file_path' already exists. No action taken."
  else
    touch "$file_path" && echo "File '$file_path' created."
    chown "$owner" "$file_path" && echo "Ownership of '$file_path' set to '$owner'."
    chmod "$permissions" "$file_path" && echo "Permissions for '$file_path' set to $permissions."
  fi
}

# Create directories and files
create_directory "$user_home/.ansible_config" "$username:$username" 700
create_directory "/var/log/ansible" "$username:$username" 744
create_directory "$user_home/.ssh" "$username:$username" 700
create_file "$user_home/.ssh/ssh_config" "$username:$username" 600

exit 0
