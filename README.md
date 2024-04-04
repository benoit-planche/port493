**README - Déploiement de l'Application Cadavre-Exquis sur OVH**

Ce README détaille les étapes nécessaires pour déployer l'application Cadavre-Exquis sur l'infrastructure OVH en utilisant Terraform et Ansible pour la gestion des ressources et Kubernetes pour l'orchestration des conteneurs. Cadavre-Exquis est une application web fournie par M. Teychene.

---

### Prérequis

Avant de commencer le processus de déploiement, assurez-vous que votre environnement répond aux prérequis suivants :

- Terraform (testé avec la version 1.7.3)
- Ansible (testé avec la version 2.14.3)
- Kubectl (testé avec la version 1.28.2)
- Compte OVH avec les autorisations nécessaires pour créer et gérer des ressources

### Étapes de Déploiement

Suivez ces étapes pour déployer l'application Cadavre-Exquis :

1. **Cloner le Répertoire distant Git :**
git clone https://github.com/benoit-planche/port493.git

2. **Configurer Terraform :**
- Assurez-vous que votre configuration Terraform est correctement configurée pour accéder aux API OVH. Utilisez les variables d'environnement ou configurez les fichiers Terraform en conséquence.
- Assurez-vous que votre fichier `terraform/create-cluster.tf` est correctement configuré avec les ressources nécessaires pour déployer votre cluster Kubernetes sur OVH.

3. **Déployer le Cluster Kubernetes avec Terraform :**
cd port493/terraform
terraform init
terraform apply

Suivez les instructions et confirmez le déploiement lorsque Terraform le demande.

4. **Déployer les Ressources Kubernetes :**
cd ../kubernetes
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f dispatcher.yaml
kubectl apply -f ingress.yaml


5. **Accéder à l'Application :**
Une fois que toutes les ressources ont été déployées avec succès, utilisez la configuration de votre Ingress pour accéder à l'application. Assurez-vous que les règles de routage appropriées sont configurées dans votre infrastructure pour diriger le trafic vers l'application.

### Points d'Attention

- Assurez-vous que les ressources Terraform sont correctement configurées pour déployer votre cluster Kubernetes sur OVH.
- Vérifiez que les services Kubernetes nécessaires sont déployés et fonctionnent correctement.
- Veillez à ce que les règles de routage de l'Ingress soient correctement configurées pour diriger le trafic vers l'application.
- [Autres points d'attention spécifiques à votre application].

---

En suivant ces étapes, vous devriez pouvoir déployer l'application Port493 avec succès sur l'infrastructure OVH en utilisant Terraform pour la gestion des ressources. En cas de problèmes ou de questions, n'hésitez pas à consulter la documentation supplémentaire ou à contacter l'équipe de développement.