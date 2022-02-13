# Raspberry Pi Ansible Bootstrap
This contains code to provision a Raspberry Pi with Ansible, NodeJS, and PM2 and run a given NodeJS application. A cron job is also setup to run the `provision.yml` playbook every 5 minutes. Note that a key task in the playbook is pulling down the latest code from the `main` branch of this repository. 

## Usage
SSH into the Raspberry Pi, as root or a user that is able to sudo, and download the bootstrap Bash script from this repo:

```bash
wget https://raw.githubusercontent.com/aautar/raspberry-pi-ansible-bootstrap/main/bootstrap.sh
```

Modify permissions on the file to allow execution and run the script.
```bash
chmod +x bootstrap.sh
```

The script can now be run and takes 2 arguments:
  - (REQUIRED) `nodejs-application-repo-url`: the URL of the Git application repository
  - (OPTIONAL) `secrets-file-url`: an SCP path (e.g. `user@remote-host:path/to/remote/file.ext`) containing secrets for the application, which will be injected as environment variables for the application

```bash
./bootstrap.sh <nodejs-application-repo-url> [secrets-file-url]
```
### Private repositories
If the application repo pointed to is private, you will need to ensure Git can access the repo without a password. For GitHub, this means you need to [add a deploy key](https://docs.github.com/en/developers/overview/managing-deploy-keys) to the repo with the public key for the user `ansible_user` which is created by the bootstrap script.

You can get the public key via `tail /home/ansible_user/.ssh/id_rsa.pub`

### Secrets 
If the application requires secrets, the app-tasks playbook will attempt to download the file via SCP. 

## Limitations
- Setup is only for a NodeJS application
- Setup is only for a single application
