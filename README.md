## Déploiement de l'application Cadavre-Exquis sur OVH

Ce README détaille les étapes nécessaires pour déployer l'application Cadavre-Exquis sur l'infrastructure OVH en utilisant Terraform et Ansible pour la gestion des ressources et Kubernetes pour l'orchestration des conteneurs. Cadavre-Exquis est une application web fournie par M. Teychene.

---

### Prérequis

Avant de commencer le processus de déploiement, assurez-vous que votre environnement répond aux prérequis suivants :

- Terraform (testé avec la version 1.7.3)
- Ansible (testé avec la version 2.14.3)
- Kubectl (testé avec la version 1.28.2)
- Avoir un compte OVH

### Installation

#### Création des accès API OVH
Documentation utilisée : [Premiers pas avec les API OVHcloud](https://help.ovhcloud.com/csm/fr-api-getting-started-ovhcloud-api?id=kb_article_view&sysparm_article=KB0042789).

1. Accédez à la page de génération des tokens API : [Créer des tokens API OVHcloud](https://www.ovh.com/auth/api/createToken).
2. Renseignez les champs `Application name` et `Application description`. 
3. Configurez les droits `GET` et `POST` avec l'annotation `/*`.
4. Cliquez sur `Create` pour générer les tokens `Application key`, `Application secret` et `Consumer key`.

#### Préparation de l'environnement

1. **Clonez le Répertoire distant Git :**
```bash
git clone https://github.com/benoit-planche/port493.git
```

```bash
cd port493
```

2. **Configurez Terraform :**
- Créez le fichier `./providers.tf` depuis `./providers.tf.example`. 
```bash
cd ./terraform
cp providers.tf.example providers.tf
```
- Utilisez les accès générés précédemment en renseignant les paramètres `application_key`, `application_secret`, `consumer_key` dans le fichier `./providers.tf`.

### Installation 

1. **Avec le script magique**
Nous avons développé un script bash qui permet de créer les instances sur ovh et de déployer les clusters Kubernetes. 
**Attention** : Avant de l'utiliser, veillez à créer un fichier `.env` en utilisant la structure du fichier `.env.template` et à saisir les chemins relatifs vers vos clés ssh. 
Une fois cela fait, exécutez le script :

```bash
./setup.sh
```

2. **Sans le script magique**

a. Déployez le cluster Kubernetes avec Terraform :
```bash
terraform init
terraform apply -auto-approve -var "ssh_key=$HOME/.ssh/<key.pub>"
```
**Attention** : Veillez à remplacer `<key.pub>` par une de vos clés ssh publiques.

b. Installez k3s sur les machines déployées

i. Créez le fichier inventaire
```bash
cd ../k3s-ansible
cat << EOT
---
k3s_cluster:
  children:
    server:
      hosts:
        {MASTER1_IP}:
        {MASTER2_IP}:
    agent:
      hosts:
        {WORKER1_IP}:
        {WORKER2_IP}:
        {WORKER3_IP}:

  # Required Vars
  vars:
    ansible_port: 22
    ansible_user: debian
    k3s_version: v1.26.9+k3s1
    token: "mytoken"  # Use ansible vault if you want to keep it secret
    api_endpoint: "{{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}"
    extra_server_args: ""
    extra_agent_args: ""
    airgap_dir: "./airgap"
    kubeconfig: "../../kubeconfig.yaml"
EOT > ./inventory.yaml
```

**Attention** : Veillez à remplacer `MASTER1_IP`, `MASTER2_IP`, `WORKER1_IP`, `WORKER2_IP`, `WORKER3_IP` par les adresses IP correspondantes dans la sortie du script Terraform.

ii. Exécutez le script Ansible
```bash
ansible-playbook -i inventory.yml playbook/site.yml --key-file "$HOME/.ssh/<key>"
```
**Attention** : Veillez à remplacer `<key>` par la clé ssh privée en lien avec la clé publique utilisée au _2.a_.

c. Déployez les ressources Kubernetes :

i. Configurez kubctl
```bash
kubectl config use-context k3s-ansible --kubeconfig=kubeconfig.yaml
```
ii. Déployez l'application via kubctl
```bash
kubectl --kubeconfig=kubeconfig.yaml apply -f ./kubernetes
```

d. Accédez à l'application :
Une fois que toutes les ressources ont été déployées avec succès, utilisez la configuration de l'Ingress pour accéder à l'application.

### Points d'Attention

- Assurez-vous que les ressources Terraform sont correctement configurées pour déployer votre cluster Kubernetes sur OVH.
- Vérifiez que les services Kubernetes nécessaires sont déployés et fonctionnent correctement.
- Veillez à ce que les règles de routage de l'Ingress soient correctement configurées pour diriger le trafic vers l'application.

---

En suivant ces étapes, vous devriez pouvoir déployer l'application Port493 avec succès sur l'infrastructure OVH en utilisant Terraform pour la gestion des ressources. En cas de problèmes ou de questions, n'hésitez pas à consulter la documentation supplémentaire ou à contacter l'équipe de développement.

### Références
Nous avons utilisé un projet Ansible existant sur GitHub pour déployer les configurations k3s sur nos machines OVH : [k3s-ansible](https://github.com/k3s-io/k3s-ansible.git).