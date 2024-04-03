resource "openstack_compute_keypair_v2" "test_keypair" {
  provider   = openstack.ovh             # Nom du fournisseur déclaré dans provider.tf
  name       = "ssh-port493"            # Nom de la clé SSH à utiliser pour la création
  public_key = file("~/.ssh/id_ed25519_DO.pub") # Chemin vers votre clé SSH précédemment générée
}

resource "openstack_compute_instance_v2" "master" {
  name        = "Port493-Master1"    # Nom de l'instance
  provider    = openstack.ovh           # Nom du fournisseur
  image_name  = "Debian 12"             # Nom de l'image
  flavor_name = "b3-16"                  # Nom du type d'instance
  # Nom de la ressource openstack_compute_keypair_v2 nommée test_keypair
  key_pair    = openstack_compute_keypair_v2.test_keypair.name
  network {
    name = "Ext-Net" # Ajoute le composant réseau pour atteindre votre instance
  }
}

resource "openstack_compute_instance_v2" "master2" {
  name        = "Port493-Master2"    # Nom de l'instance
  provider    = openstack.ovh           # Nom du fournisseur
  image_name  = "Debian 12"             # Nom de l'image
  flavor_name = "b3-16"                  # Nom du type d'instance
  # Nom de la ressource openstack_compute_keypair_v2 nommée test_keypair
  key_pair    = openstack_compute_keypair_v2.test_keypair.name
  network {
    name = "Ext-Net" # Ajoute le composant réseau pour atteindre votre instance
  }
}

resource "openstack_compute_instance_v2" "node1" {
  name        = "Port493-Node1"    # Nom de l'instance
  provider    = openstack.ovh           # Nom du fournisseur
  image_name  = "Debian 12"             # Nom de l'image
  flavor_name = "b3-16"                  # Nom du type d'instance
  # Nom de la ressource openstack_compute_keypair_v2 nommée test_keypair
  key_pair    = openstack_compute_keypair_v2.test_keypair.name
  network {
    name = "Ext-Net" # Ajoute le composant réseau pour atteindre votre instance
  }
}

resource "openstack_compute_instance_v2" "node2" {
  name        = "Port493-Node2"    # Nom de l'instance
  provider    = openstack.ovh           # Nom du fournisseur
  image_name  = "Debian 12"             # Nom de l'image
  flavor_name = "b3-16"                  # Nom du type d'instance
  # Nom de la ressource openstack_compute_keypair_v2 nommée test_keypair
  key_pair    = openstack_compute_keypair_v2.test_keypair.name
  network {
    name = "Ext-Net" # Ajoute le composant réseau pour atteindre votre instance
  }
}

resource "openstack_compute_instance_v2" "node3" {
  name        = "Port493-Node3"    # Nom de l'instance
  provider    = openstack.ovh           # Nom du fournisseur
  image_name  = "Debian 12"             # Nom de l'image
  flavor_name = "b3-16"                  # Nom du type d'instance
  # Nom de la ressource openstack_compute_keypair_v2 nommée test_keypair
  key_pair    = openstack_compute_keypair_v2.test_keypair.name
  network {
    name = "Ext-Net" # Ajoute le composant réseau pour atteindre votre instance
  }
}

output "ip-master1" {
  value = openstack_compute_instance_v2.master.access_ip_v4
}

output "ip-master2" {
  value = openstack_compute_instance_v2.master2.access_ip_v4
}

output "ip-node1" {
  value = openstack_compute_instance_v2.node1.access_ip_v4
}

output "ip-node2" {
  value = openstack_compute_instance_v2.node2.access_ip_v4
}

output "ip-node3" {
  value = openstack_compute_instance_v2.node3.access_ip_v4
}