# Automation Scripts
Linux Bash, Python scripts to automate installation, system administratotion.

**Installing and creating ansible user to manage servers - bash script.**
```
sudo bash ansible_preparation_with_user.sh
```


## Install and prepre ansible host for automation and security host automation
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
