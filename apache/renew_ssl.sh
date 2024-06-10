#!/bin/bash

# sh  renew_ssl.sh

# Vérifier que l'utilisateur est root
if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté en tant que root." >&2
  exit 1
fi

# Renouveler les certificats SSL avec Certbot
certbot renew --quiet

# Redémarrer Apache pour appliquer les nouveaux certificats
service apache2 restart
