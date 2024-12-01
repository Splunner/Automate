#!/bin/bash

# Prompt user for the path to ansible.cfg
read -p "Enter the full path to ansible.cfg: " ansible_cfg_path

# Verify the path exists
if [ ! -f "$ansible_cfg_path" ]; then
  echo "Error: File not found at $ansible_cfg_path"
  exit 1
fi

# Add ANSIBLE_CONFIG to ~/.bashrc
if ! grep -q "export ANSIBLE_CONFIG=" ~/.bashrc; then
  echo "export ANSIBLE_CONFIG=$ansible_cfg_path" >> ~/.bashrc
  echo "ANSIBLE_CONFIG added to ~/.bashrc successfully."
else
  sed -i "s|^export ANSIBLE_CONFIG=.*|export ANSIBLE_CONFIG=$ansible_cfg_path|" ~/.bashrc
  echo "ANSIBLE_CONFIG updated in ~/.bashrc."
fi

# Reload ~/.bashrc
source ~/.bashrc
