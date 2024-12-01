import os
from jinja2 import Template
import sys

# Check if the script is run as sudo
if os.geteuid() != 0:
    print("This script must be run as sudo to create files in '/var/log'.")
    sys.exit(1)

# Get current user
current_user = os.getenv("SUDO_USER") or os.getlogin()
default_path = f"/home/{current_user}"

# Ask user for output path
output_path = input(f"Enter the path to save 'ansible.cfg' (default: {default_path}): ").strip()
if not output_path:
    output_path = default_path

# Ensure the output path exists
if not os.path.exists(output_path):
    print(f"Path '{output_path}' does not exist!")
    exit(1)

# Paths
script_dir = os.path.dirname(os.path.abspath(__file__))  # Directory of the script
j2_file = os.path.join(script_dir, "ansible_config.cfg.j2")  # Path to Jinja2 template
output_file = os.path.join(output_path, "ansible.cfg")
log_file = "/var/log/ansible.log"  # Log file path

# Check if Jinja2 template file exists
if not os.path.exists(j2_file):
    print(f"Jinja2 template file '{j2_file}' not found in '{script_dir}'! Please ensure the template exists.")
    exit(1)

# Read Jinja2 template
with open(j2_file, 'r') as template_file:
    template_content = template_file.read()

# Check if template content is empty
if not template_content.strip():
    print("Error: The Jinja2 template file is empty!")
    exit(1)

# Render template
template = Template(template_content)
rendered_content = template.render(user=current_user, log_path=log_file)  # Pass log path to the template

# Write to ansible.cfg
with open(output_file, 'w') as ansible_cfg:
    ansible_cfg.write(rendered_content)

# Set permissions and ownership for ansible.cfg
os.chmod(output_file, 0o700)  # Owner read/write/execute only
os.system(f"chown {current_user}:{current_user} {output_file}")

# Ensure /var/log/ansible.log exists
if not os.path.exists(log_file):
    with open(log_file, 'w') as log:
        pass  # Create an empty log file

# Set permissions for ansible.log
os.chmod(log_file, 0o660)  # Owner and group read/write only
os.system(f"chown {current_user}:{current_user} {log_file}")

# Print confirmation
print(f"'{output_file}' generated and secured for user '{current_user}'.")
print(f"Log file '{log_file}' created with group write and read permissions.")
