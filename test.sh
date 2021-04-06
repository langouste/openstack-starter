#!/bin/bash

# Generate a new keypair with 'n' reponse to 'Overwrite (y/n)?' question
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ovhcloud -N '' <<< n

source openrc.sh

terraform init

terraform apply -auto-approve && \
# Wait for SSH connection available
sleep 2 && \
ansible-playbook site.yml
