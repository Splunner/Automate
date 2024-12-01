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

# Create the user
if id "$username" &>/dev/null; then
  echo "User '$username' already exists."
else
  useradd -m -s /bin/bash "$username" && echo "User '$username' created."

  # Add user to the 'wheel' group for RHEL/CentOS/Oracle Linux
  if grep -q -E "rhel|centos|oracle" /etc/os-release; then
    usermod -aG wheel "$username"
    echo "User '$username' added to the 'wheel' group (sudo permissions)."
  else
    # Fallback to sudo group for other distributions
    usermod -aG sudo "$username"
    echo "User '$username' added to the 'sudo' group (sudo permissions)."
  fi

  # Create the '.ansible_config' directory in the user's home directory
  user_home=$(eval echo ~$username)
  mkdir -p "$user_home/.ansible_config" && echo "Directory '.ansible_config' created in $user_home."
  mkdir -p "/var/log/ansible/" && echo "Directory '/var/log/ansible/' created in $user_home."
  # Set ownership of the '.ansible_config' directory to the user
  chown "$username":"$username" "$user_home/.ansible_config" && echo "Ownership of '.ansible_config' set to '$username'."
  chown "$username":"$username" "/var/log/ansible" && echo "Ownership of '/var/log/ansible' set to '$username'."
  # Set the appropriate permissions for the directory (read, write, execute)
  chmod 700 "$user_home/.ansible_config" && echo "Permissions for '.ansible_config' set to 700 (read, write, execute for the user)."
  chmod 744 -R "/var/log/ansible" && echo "Permissions for '/var/log/ansible' set to 700 (read, write, execute for the user)."
fi

exit 0
