#!/bin/bash

echo "Writing secrets URL file"
sudo -u ansible_user mkdir -p /home/ansible_user/.app/
sudo -u ansible_user touch /home/ansible_user/.app/app-secrets-url.txt
echo "$1" | sudo -u ansible_user tee /home/ansible_user/.app/app-secrets-url.txt > /dev/null

read -p "Enter password for secrets URL target: " -s pw
echo "$pw" | sudo -u ansible_user tee /home/ansible_user/.app/app-secrets-remote-password.txt > /dev/null
