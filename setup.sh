#!/bin/bash

source .env
cd terraform
terraform init
terraform apply -auto-approve -var "ssh_key=$PUBLIC_SSH_KEY_PATH"
cd ../k3s-ansible
sleep 5
ansible-playbook -i inventory.yml playbook/site.yml --key-file "$PRIVATE_SSH_KEY_PATH"
cd ..
kubectl config use-context k3s-ansible --kubeconfig=kubeconfig.yaml
kubectl apply -f ./kubernetes --kubeconfig=kubeconfig.yaml