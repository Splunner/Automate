#!/bin/bash

# Default values
default_ansibleautomatedirectory="ansible-automate"
default_techt="techt"
default_hostSecOPS="false"
default_operatoruser="operator_ansible"
default_new_host_user_server="testuser"
default_ssh_key_name="techt_key"

# Prompt for ansible-automate directory name
read -p "Enter the directory name for ansible automation (default: $default_ansibleautomatedirectory): " ansibleautomatedirectory
ansibleautomatedirectory=${ansibleautomatedirectory:-$default_ansibleautomatedirectory}

# Prompt user for the path to ansible.cfg
read -p "Enter the full path to ansible.cfg: " ansible_cfg_path

# Verify the path exists
if [ ! -f "$ansible_cfg_path" ]; then
  echo "Error: File not found at $ansible_cfg_path"
  exit 1
fi

# Prompt for techt variable
read -p "Enter the default user on the remote system (default: $default_techt): " techt
techt=${techt:-$default_techt}

# Prompt for hostSecOPS variable
read -p "Enable SecOPS host (true/false, default: $default_hostSecOPS): " hostSecOPS
hostSecOPS=${hostSecOPS:-$default_hostSecOPS}

# Prompt for operatoruser variable
read -p "Enter the default operator user (default: $default_operatoruser): " operatoruser
operatoruser=${operatoruser:-$default_operatoruser}

# Prompt for new_host_user_server variable
read -p "Enter the default host user server (default: $default_new_host_user_server): " new_host_user_server
new_host_user_server=${new_host_user_server:-$default_new_host_user_server}

# Prompt for SSH directory
read -p "Enter the directory for SSH keys (default: $HOME/.ssh/): " ssh_dir
ssh_dir=${ssh_dir:-"$HOME/.ssh"}

# Prompt for SSH key name
read -p "Enter the SSH key name (default: $default_ssh_key_name): " ssh_key_name
ssh_key_name=${ssh_key_name:-$default_ssh_key_name}

# Set SSH key path
ssh_key_path="$ssh_dir/$ssh_key_name"

# Add or update ANSIBLE_CONFIG in ~/.bashrc
if ! grep -q "export ANSIBLE_CONFIG=" ~/.bashrc; then
  echo "export ANSIBLE_CONFIG=$ansible_cfg_path" >> ~/.bashrc
  echo "ANSIBLE_CONFIG added to ~/.bashrc successfully."
else
  sed -i "s|^export ANSIBLE_CONFIG=.*|export ANSIBLE_CONFIG=$ansible_cfg_path|" ~/.bashrc
  echo "ANSIBLE_CONFIG updated in ~/.bashrc."
fi

# Add or update CONFIG_VARIABLES in ~/.bashrc
if ! grep -q "export CONFIG_VARIABLES=" ~/.bashrc; then
  echo "export CONFIG_VARIABLES=\"\$HOME/$ansibleautomatedirectory/config-variables/\"" >> ~/.bashrc
  echo "CONFIG_VARIABLES added to ~/.bashrc successfully."
else
  sed -i "s|^export CONFIG_VARIABLES=.*|export CONFIG_VARIABLES=\"\$HOME/$ansibleautomatedirectory/config-variables/\"|" ~/.bashrc
  echo "CONFIG_VARIABLES updated in ~/.bashrc."
fi

# Add or update TECHT variable in ~/.bashrc
if ! grep -q "export DEFAULTREMOTEUSER=" ~/.bashrc; then
  echo "export DEFAULTREMOTEUSER=$techt" >> ~/.bashrc
  echo "DEFAULTREMOTEUSER added to ~/.bashrc successfully."
else
  sed -i "s|^export DEFAULTREMOTEUSER=.*|export DEFAULTREMOTEUSER=$techt|" ~/.bashrc
  echo "DEFAULTREMOTEUSER updated in ~/.bashrc."
fi

# Add or update HOST_SEC_OPS variable in ~/.bashrc
if ! grep -q "export HOST_SEC_OPS=" ~/.bashrc; then
  echo "export HOST_SEC_OPS=$hostSecOPS" >> ~/.bashrc
  echo "HOST_SEC_OPS added to ~/.bashrc successfully."
else
  sed -i "s|^export HOST_SEC_OPS=.*|export HOST_SEC_OPS=$hostSecOPS|" ~/.bashrc
  echo "HOST_SEC_OPS updated in ~/.bashrc."
fi

# Add or update OPERATOR_USER variable in ~/.bashrc
if ! grep -q "export OPERATOR_USER=" ~/.bashrc; then
  echo "export OPERATOR_USER=$operatoruser" >> ~/.bashrc
  echo "OPERATOR_USER added to ~/.bashrc successfully."
else
  sed -i "s|^export OPERATOR_USER=.*|export OPERATOR_USER=$operatoruser|" ~/.bashrc
  echo "OPERATOR_USER updated in ~/.bashrc."
fi

# Add or update NEW_HOST_USER_SERVER variable in ~/.bashrc
if ! grep -q "export NEW_HOST_USER_SERVER=" ~/.bashrc; then
  echo "export NEW_HOST_USER_SERVER=$new_host_user_server" >> ~/.bashrc
  echo "NEW_HOST_USER_SERVER added to ~/.bashrc successfully."
else
  sed -i "s|^export NEW_HOST_USER_SERVER=.*|export NEW_HOST_USER_SERVER=$new_host_user_server|" ~/.bashrc
  echo "NEW_HOST_USER_SERVER updated in ~/.bashrc."
fi

# Add or update SSHDIRECTOR variable in ~/.bashrc
if ! grep -q "export SSHDIRECTOR=" ~/.bashrc; then
  echo "export SSHDIRECTOR=$ssh_dir" >> ~/.bashrc
  echo "SSHDIRECTOR added to ~/.bashrc successfully."
else
  sed -i "s|^export SSHDIRECTOR=.*|export SSHDIRECTOR=$ssh_dir|" ~/.bashrc
  echo "SSHDIRECTOR updated in ~/.bashrc."
fi

# Add or update SSHREMOTEUSERKEYNAME variable in ~/.bashrc
if ! grep -q "export SSHREMOTEUSERKEYNAME=" ~/.bashrc; then
  echo "export SSHREMOTEUSERKEYNAME=$ssh_key_name" >> ~/.bashrc
  echo "SSHRREMOTEUSERKEYNAME added to ~/.bashrc successfully."
else
  sed -i "s|^export SSHREMOTEUSERKEYNAME=.*|export SSHREMOTEUSERKEYNAME=$ssh_key_name|" ~/.bashrc
  echo "SSHRREMOTEUSERKEYNAME updated in ~/.bashrc."
fi

# Add or update SSHREMOTEUSERSSHKEY variable in ~/.bashrc
if ! grep -q "export SSHREMOTEUSERSSHKEY=" ~/.bashrc; then
  echo "export SSHREMOTEUSERSSHKEY=$ssh_key_path" >> ~/.bashrc
  echo "SSHRREMOTEUSERSSHKEY added to ~/.bashrc successfully."
else
  sed -i "s|^export SSHREMOTEUSERSSHKEY=.*|export SSHREMOTEUSERSSHKEY=$ssh_key_path|" ~/.bashrc
  echo "SSHRREMOTEUSERSSHKEY updated in ~/.bashrc."
fi

# Reload ~/.bashrc
source ~/.bashrc

# Final message
echo "Configuration complete. The following changes have been applied to ~/.bashrc:"
echo "  - ANSIBLE_CONFIG=$ansible_cfg_path"
echo "  - CONFIG_VARIABLES=\$HOME/$ansibleautomatedirectory/config-variables/"
echo "  - TECHT=$techt"
echo "  - HOST_SEC_OPS=$hostSecOPS"
echo "  - OPERATOR_USER=$operatoruser"
echo "  - NEW_HOST_USER_SERVER=$new_host_user_server"
echo "  - SSHDIRECTOR=$ssh_dir"
echo "  - SSHREMOTEUSERKEYNAME=$ssh_key_name"
echo "  - SSHREMOTEUSERSSHKEY=$ssh_key_path"
