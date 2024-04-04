**README - Déploiement de l'Application Cadavre-Exquis sur OVH**

Ce README détaille les étapes nécessaires pour déployer l'application Cadavre-Exquis sur l'infrastructure OVH en utilisant Terraform et Ansible pour la gestion des ressources et Kubernetes pour l'orchestration des conteneurs. Cadavre-Exquis est une application web fournie par M. Teychene.

---

### Prérequis

Avant de commencer le processus de déploiement, assurez-vous que votre environnement répond aux prérequis suivants :

- Terraform (testé avec la version 1.7.3)
- Ansible (testé avec la version 2.14.3)
- Kubectl (testé avec la version 1.28.2)
- Avoir un compte OVH

### Créer des accès API OVH
Documentation utilisée : https://help.ovhcloud.com/csm/fr-public-cloud-compute-terraform?id=kb_article_view&sysparm_article=KB0050792

1. Accédez à la page de génération des tokens API
Lien : https://www.ovh.com/auth/?onsuccess=https%3A%2F%2Fwww.ovh.com%2Fauth%2Fapi%2FcreateToken%3FGET%3D%2F%2A%26POST%3D%2F%2A%26PUT%3D%2F%2A%26DELETE%3D%2F%2A

2. Générez les tokens
Renseignez les champs tels que `Application name` et `Application description`. Cliquez sur `Create` pour générer les tokens `Application key`, `Application secret` et `Consumer key`.

### Étapes de Déploiement

Suivez ces étapes pour déployer l'application Cadavre-Exquis :

1. **Cloner le Répertoire distant Git :**
git clone https://github.com/benoit-planche/port493.git

Pour la suite de la documentation, rendez-vous à la racine du projet git cloné.
```bash
cd port493
```

2. **Configurer Terraform :**
- Assurez-vous que votre configuration Terraform est correctement configurée pour accéder aux API OVH. Créer une copie du fichier `./terraform/providers.tf.example` appelé `./terraform/providers.tf`. 
```bash
cd ./terraform
cp providers.tf.example providers.tf
```
Utiliser les accès généré précédemment en renseignant les paramètres `application_key`, `application_secret`, `consumer_key` dans le fichier `./terraform/providers.tf`.

Dans le fichier `create-cluster.tf`, dans la ressource `test_keypair`, l'attribut `public_key` permet de renseigner une clée ssh publique permettant de vous connecter en ssh aux différentes instances OVH créées. Veillez à utiliser une de vos clées ssh local. 

3. **Déployer le Cluster Kubernetes avec Terraform :**
```bash
terraform init
terraform apply
```

Suivez les instructions et confirmez le déploiement lorsque Terraform le demande.

4. **Installer k3s dans les Cluster déployé**

a. Créer le fichier inventaire
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

Bien evidemment il faut remplacer `MASTER1_IP`, `MASTER2_IP`, `WORKER1_IP`, `WORKER2_IP`, `WORKER3_IP` par les adresses IP correspondantes dans la sortie du script terraform.

b. Executer le script Ansible
```bash
ansible-playbook sites.yaml -i inventory.yaml
```

5. **Déployer les Ressources Kubernetes :**

a. Configurer kubctl
```bash
kubectl config use-context k3s-ansible --kubeconfig=kubeconfig.yaml
```
b. Déployer l'application via kubctl
```bash
kubectl --kubeconfig=kubeconfig.yaml apply -f ./kubernetes
```

6. **Accéder à l'Application :**
Une fois que toutes les ressources ont été déployées avec succès, utilisez la configuration de l'Ingress pour accéder à l'application.

### Points d'Attention

- Assurez-vous que les ressources Terraform sont correctement configurées pour déployer votre cluster Kubernetes sur OVH.
- Vérifiez que les services Kubernetes nécessaires sont déployés et fonctionnent correctement.
- Veillez à ce que les règles de routage de l'Ingress soient correctement configurées pour diriger le trafic vers l'application.

---

En suivant ces étapes, vous devriez pouvoir déployer l'application Port493 avec succès sur l'infrastructure OVH en utilisant Terraform pour la gestion des ressources. En cas de problèmes ou de questions, n'hésitez pas à consulter la documentation supplémentaire ou à contacter l'équipe de développement.