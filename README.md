


# Table of Contents

- [Ansible](#Ansible)
    -   [Install new Host for Ansible or Secure Ansible Host](#install-and-prepre-ansible-host-for-automation-and-security-host-automation)
    -   [Ansible directory strategies](#directories)
    -   [Ansible configuration structure](#ansible-configuration-structure)
    -   [Installation Process](#installation)
    -   [Ansible Role template]
- [Config files](#)

**Installing and creating ansible user to manage servers - bash script.**
```
sudo bash ansible_preparation_with_user.sh
```


## Ansible 

### Install and prepre ansible host for automation and security host automation
Requirements:

- 1 host for ansible automation

- 1 host at least for secure tasks automation (certififcations, secure tasks deployment, high secure jobs)

Users:

- **operator_ansible** for standard tasks with sudo user on endpoints (techt)
- **sec_ansible** for security tasks with sudo suer on endpoints (techt)


How to build hosts for such jobs below.

To secure access connection use this anisble role:
in progress build vpn connection with firewall + port knocking

To secure ssh connection use this ansible role:
ssh certifificate base or key base only 


### Directories
$HOME/.ansible_config - config directory for custom ansible and ansible.cfg

$HOME/.ansible_config/inventory - inventory directory

/var/log/ansible/anisble.log - log directory for ansible script. 

<sub>*Permission applied for the specific user, creation of this directory once user is created using script.</sub>


### Ansible configuration structure:

From documentation you can defined multiple ways  of configuration.

ANSIBLE_CONFIG (environment variable if set)
 
$HOME/.ansible_config/ansible/ansible.cfg (in the current directory) - By this repo

~/.ansible.cfg (in the home directory)

/etc/ansible/ansible.cfg

 

 

Under this link there is list which envoironment variables you can set and which can be set in asnible.cfg.

https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-home

 

 

Important options by envoironment variable in system which should be setup

ANSIBLE_HOME=$HOME/.ansible_config/ansible/ansible.cfg

* Can be deploy by this script :

 

Below keys which can be setup in ansible.cfg and environment variables

| Ansible.cfg Option         | ENV Variable                     | Description                                                                                         |
|----------------------------|-----------------------------------|-----------------------------------------------------------------------------------------------------|
| `host_key_checking`        | `ANSIBLE_HOST_KEY_CHECKING`      |                                                                                                     |
| `vault_encrypt_salt`       | `ANSIBLE_VAULT_ENCRYPT_SALT`     |                                                                                                     |
| `playbook_dir`             | `ANSIBLE_PLAYBOOK_DIR`           |                                                                                                     |
| `task_timeout`             | `ANSIBLE_TASK_TIMEOUT`           |                                                                                                     |
| `private_key_file`         | `ANSIBLE_PRIVATE_KEY_FILE`       | Option for connections using a certificate or key file to authenticate, rather than an agent or passwords |


                                                                       


## Installation
<b>Follow the steps below to create host base for ansible run time.</b>

```

#Clone repository
git clone https://github.com/Splunner/Automate.git


#run script to create and map alias for your user:
bash $HOME/Automate/helper/add_alias_global.sh

#run this command to create operator_ansible or sec_ansible or techt user
sudo bash $AutomateDirectory/ansible/ansible_manager/anisble_user.sh
## this creates user, log directory and set permisisons.

#install pip3 from remote or local repository #check this directory: 
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

#install ansible
python3 -m pip install --user ansible
pip3 install jinja2



#run command below to generate ansible config cfg.   
python3 $AutomateDirectory/ansible/ansible_config/generate_ansible_cfg.py
## this creates ansible config in your home user directory


#run set global variable to set such thigs as inventory global path,

```



## Ansible role template schema


roles/

└── <role_name> /

    ├── defaults/
    │   └── main.yml           # Default variables for the role
    ├── files/
    │   └── <files>            # Static files to be copied (e.g., config files, binaries)
    ├── handlers/
    │   └── main.yml           # Handlers triggered by tasks
    ├── meta/
    │   └── main.yml           # Role metadata (dependencies, author, license, etc.)
    ├── tasks/
    │   └── main.yml           # Main task file, includes other task files if needed
    │   └── <additional_tasks>.yml  # Optional task files for organization
    ├── templates/
    │   └── <template_files>   # Jinja2 templates to be rendered dynamically
    ├── vars/
    │   └── main.yml           # Variables with higher precedence than defaults
    ├── tests/
    │   ├── inventory          # Test inventory file for the role
    │   └── test.yml           # Test playbook for the role
    └── README.md              # Documentation for the role



# Config Files


#### Tmux
Enable mouse, set default shell bash and synchronize it across all planes + load the config file at the end.
```
echo -e "set -g default-shell /bin/bash\nset -g mouse on\nbind -n C-x setw synchronize-panes" > ~/.tmux.conf && tmux source-file ~/.tmux.conf
```
