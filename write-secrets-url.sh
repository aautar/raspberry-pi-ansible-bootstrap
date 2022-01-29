#!/bin/bash

echo "Writing secrets URL file"
echo "$1" | sudo -u ansible_user tee /home/ansible_user/.app/app-secrets-url.txt > /dev/null
