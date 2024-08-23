#!/bin/bash

sudo apt update -y
sudo apt install ansible git -y

ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
ansible-galaxy collection install community.docker
git clone https://github.com/aaosopra/minecraft-server.git