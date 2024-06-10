#!/bin/bash

# sh  add_ssl_site.sh nom_domain.com email

# Vérifier que l'utilisateur est root
if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté en tant que root." >&2
  exit 1
fi

# Vérifier les paramètres
if [ $# -ne 2 ]; then
  echo "Usage: $0 <nom_domain.com <email>" >&2
  exit 1
fi

SITE_NAME=$1
EMAIL=$2
CONFIG_FILE="/etc/apache2/sites-available/$SITE_NAME.conf"

# Installer Certbot si nécessaire
if ! command -v certbot > /dev/null 2>&1; then
  echo "Installation de Certbot..."
  apt update
  apt install -y certbot python3-certbot-apache
fi

# Obtenir le certificat SSL pour le domaine
certbot --apache -d $SITE_NAME --non-interactive --agree-tos --email $EMAIL

# Ajouter la redirection HTTP vers HTTPS et configurer HTTPS
if grep -q "RewriteEngine on" $CONFIG_FILE; then
  echo "La redirection HTTP vers HTTPS est déjà configurée dans $CONFIG_FILE."
else
  echo "Configuration de la redirection HTTP vers HTTPS et HTTPS dans $CONFIG_FILE..."
  cat << EOF > $CONFIG_FILE

<VirtualHost *:80>
    ServerName $SITE_NAME
    RewriteEngine on
    RewriteCond %{HTTPS} off
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</VirtualHost>

<VirtualHost *:443>
    ServerAdmin webmaster@localhost
    ServerName $SITE_NAME
    DocumentRoot /var/www/html/$SITE_NAME

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/$SITE_NAME/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/$SITE_NAME/privkey.pem

    <Directory /var/www/html/$SITE_NAME>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$SITE_NAME-error.log
    CustomLog \${APACHE_LOG_DIR}/$SITE_NAME-access.log combined
</VirtualHost>
EOF
fi

# Activer le module SSL et le nouveau site
a2enmod ssl
a2ensite $SITE_NAME

# Vérifier la configuration Apache
apache2ctl configtest

# Redémarrer Apache pour appliquer les changements
sudo service apache2 restart
echo "Le certificat SSL pour $SITE_NAME a été obtenu et configuré avec succès."
echo "La redirection HTTP vers HTTPS et la configuration HTTPS ont été ajoutées à $CONFIG_FILE."
