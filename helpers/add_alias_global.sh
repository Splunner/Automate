#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Function to add an alias
add_alias() {
  local alias_name="$1"
  local alias_command="$2"
  if ! grep -q "alias $alias_name=" /etc/bashrc; then
    echo "alias $alias_name='$alias_command'" >> /etc/bashrc
    echo "Alias $alias_name added successfully."
  else
    echo "Alias $alias_name already exists."
  fi
}

# Example usage
#ls
add_alias "ll" "ls -l"
add_alias "lltr" "ls -ltr"
add_alias "llhd" "ls -ltr /home/\$(whoami)"

#pwdhd - pwd home_directory
add_alias "pwdhd" "echo $HOME"

#git 
add_alias "gcm" "git commit -m"
add_alias "gs" "git status"
add_alias "gal" "git add ."


#ansible config generated file
add_alias "ans_cfg_pwd" "readlink  -f  ~/ansible.cfg"


# Reload bashrc
source /etc/bashrc
