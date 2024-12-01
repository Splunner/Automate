# Automation Scripts
Linux Bash, Python scripts to automate installation, system administratotion.







**Installing and creating ansible user to manage servers - bash script.**
```
sudo bash ansible_preparation_with_user.sh
```


# Ansible 

### Install and prepre ansible host for automation and security host automation
Requiments:

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


##### Directories
$HOME/.ansible_config - config directory for custom ansible and ansible.cfg

$HOME/.ansible_config/inventory - inventory directory

/var/log/ansible/anisble.log - log directory for ansible script. 

<sub>*Permission applied for the specific user, creation of this directory once user is created using script.</sub>



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
