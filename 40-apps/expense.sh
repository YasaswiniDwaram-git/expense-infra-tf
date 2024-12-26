#!/bin/bash

dnf install ansible -y
cd /tmp
git clone https://github.com/YasaswiniDwaram-git/Expense-ansible.git
cd Expense-ansible
ansible-playbook -i inventory.ini mysql.yaml
ansible-playbook -i inventory.ini frontend.yaml
ansible-playbook -i inventory.ini backend.yaml