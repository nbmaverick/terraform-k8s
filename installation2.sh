#!/bin/bash
sudo amazon-linux-extras install ansible2 -y
sudo yum install ansible-2.9.23 -y
ansible --version
ansible localhost -m ping
# bash build.sh