#!/bin/bash

cd terraform
terraform init
terraform apply -auto-approve
cd ../k3s-ansible
sleep 5
ansible-playbook -i inventory.yml playbook/site.yml --key-file "~/.ssh/id_ed25519_DO"
cd ..
kubectl config use-context k3s-ansible --kubeconfig=kubeconfig.yaml
kubectl apply -f ./kubernetes --kubeconfig=kubeconfig.yaml