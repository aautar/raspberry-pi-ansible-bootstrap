# Raspberry Pi Ansible Bootstrap
This contains code to provision a Raspberry Pi with Ansible, NodeJS, and PM2 and run a given NodeJS application. A cron job is also setup to run the `provision.yml` playbook every 5 minutes. Note that a key task in the playbook is pulling down the latest code from the `main` branch of this repository. 

## Usage
SSH into the Raspberry Pi, as root or a user that is able to sudo, and download the bootstrap Bash script from this repo:

```
wget https://raw.githubusercontent.com/aautar/raspberry-pi-ansible-bootstrap/main/bootstrap.sh
```

Modify permissions on the file to allow execution and run the script. The script takes 1 argument, the repo of a NodeJS app to setup on the Raspberry Pi:
```
chmod +x bootstrap.sh
./bootstrap.sh git@github.com:<some-nodejs-app-repo>
```

If the NodeJS application repo pointed to is private, you will need to [add a deploy key](https://docs.github.com/en/developers/overview/managing-deploy-keys) to the repo with the public key for the user `ansible_user` which is created by the bootstrap script.

