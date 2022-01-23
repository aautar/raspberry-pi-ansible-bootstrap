#!/bin/bash
sudo apt-get install software-properties-common -y

sudo apt-get update -y
sudo apt-get install acl -y
sudo apt-get install sshpass -y
sudo apt-get install ansible -y

sudo cp /etc/hosts /etc/ansible/hosts

# Write app repo URL to file
echo "$1" > /home/ansible_user/code/raspberry-pi-ansible-bootstrap/app-repo-url.txt

# Generate ansible user
ansible_user_random_password=openssl rand -hex 20
sudo useradd -d /home/ansible_user -m ansible_user -p $(openssl passwd -1 ansible_user_random_password)
sudo adduser ansible_user sudo

sudo mkdir /home/ansible_user/.ssh
sudo ssh-keygen -t rsa -N "" -f /home/ansible_user/.ssh/id_rsa
sudo cat /home/ansible_user/.ssh/id_rsa.pub >> /home/ansible_user/.ssh/authorized_keys
ssh-keyscan localhost | sudo tee /home/ansible_user/.ssh/known_hosts
sudo chown -R ansible_user /home/ansible_user/.ssh

# Add ansible_user to sudoers, no password required for sudo elevation
echo "ansible_user  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible_user

# Install Git
sudo apt install git -y

# Clone repo with bootstrap
sudo git clone https://github.com/aautar/raspberry-pi-ansible-bootstrap.git /home/ansible_user/code/raspberry-pi-ansible-bootstrap

# Enable logging for Ansible
sudo touch /var/log/ansible.log
sudo setfacl -m u:ansible_user:rwx /var/log/ansible.log
sudo sed -i 's|#log_path = /var/log/ansible.log|log_path = /var/log/ansible.log|' /etc/ansible/ansible.cfg

# Create ansible inventory
sudo touch /home/ansible_user/inventory.ini
sudo cat << 'ENDINV' > /home/ansible_user/inventory.ini
[hosts]
localhost ansible_connection=ssh ansible_user=ansible_user
ENDINV

# Run ansible playbook
export PYTHONUNBUFFERED=1
sudo -u ansible_user ansible-playbook /home/ansible_user/code/raspberry-pi-ansible-bootstrap/provision.yml -i /home/ansible_user/inventory.ini
