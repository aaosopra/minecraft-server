#!/bin/bash

sudo apt update -y
sudo apt install ansible git -y

wget ${playbook_url} -O /tmp/server_config.yaml
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
ansible-playbook /tmp/server_config.yaml --connection=local