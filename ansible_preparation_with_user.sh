#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

# Detect package manager
if grep -q "ID_LIKE=.*rhel" /etc/os-release; then
    PM="dnf"
elif grep -q "ID_LIKE=.*debian" /etc/os-release; then
    PM="apt"
else
    echo "Unsupported OS. Exiting."
    exit 1
fi

# Prompt for the username and password
read -p "Enter the username to create: " username
read -s -p "Enter the password for the user: " user_password
echo

# Create the user and set the password
useradd -m "$username"
echo "$username:$user_password" | chpasswd
echo "User $username created successfully."

# Add the user to the sudo group
if [[ $PM == "apt" ]]; then
    usermod -aG sudo "$username"
else
    usermod -aG wheel "$username"
fi
echo "User $username added to the sudo group."

# Set up SSH directory and keys
ssh_dir="/home/$username/.ssh"
mkdir -p "$ssh_dir"
chmod 700 "$ssh_dir"

read -p "Enter the private key for GitLab: " git_priv_key

# Create the private key
echo "$git_priv_key" > "$ssh_dir/git_priv.key"
chmod 600 "$ssh_dir/git_priv.key"
chown "$username:$username" "$ssh_dir/git_priv.key"

# Create the SSH config
ssh_config="$ssh_dir/config"
cat <<EOF > "$ssh_config"
Host gitlab.com
    Hostname gitlab.com
    IdentityFile ~/.ssh/git_priv.key
    User git
EOF
chmod 600 "$ssh_config"
chown "$username:$username" "$ssh_config"
echo "SSH configuration for GitLab created successfully."

# Update the system and install Git
echo "Updating the system and installing Git..."
if [[ $PM == "dnf" ]]; then
    dnf update -y && dnf install -y git
else
    apt update && apt upgrade -y && apt install -y git
fi
echo "Git installed successfully."

# Install pip
echo "Installing pip..."
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
rm -f get-pip.py

# Install Ansible for the created user
echo "Installing Ansible for $username..."
sudo -u "$username" python3 -m pip install -user ansible
echo "Ansible installed successfully for $username."

echo "Script execution completed!"
