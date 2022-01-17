#!/bin/bash
sudo apt-get install software-properties-common -y

sudo apt-get update -y
sudo apt-get install acl -y
sudo apt-get install ansible -y
sudo apt-get install sshpass -y

sudo cp /etc/hosts /etc/ansible/hosts

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

# Create folder with provisioning content
cd /raspberry-pi-ansible-bootstrap
sudo mkdir /provision
sudo cp provision.yml /provision/provision.yml
sudo cp app.js /provision/app.js

# Enable logging for Ansible
sudo touch /var/log/ansible.log
sudo setfacl -m u:ansible_user:rwx /var/log/ansible.log
sudo sed -i 's|#log_path = /var/log/ansible.log|log_path = /var/log/ansible.log|' /etc/ansible/ansible.cfg

# Create ansible inventory
sudo touch /provision/inventory.ini
sudo cat << 'ENDINV' > /provision/inventory.ini
[hosts]
localhost ansible_connection=ssh ansible_user=ansible_user
ENDINV

# Run ansible playbook
export PYTHONUNBUFFERED=1
sudo -u ansible_user ansible-playbook /provision/provision.yml -i /provision/inventory.ini
