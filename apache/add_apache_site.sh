# sh  add_apache_site.sh nom_du_site dossier_racine

# Vérifier que l'utilisateur est root
if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté en tant que root." >&2
  exit 1
fi

# Vérifier les paramètres
if [ $# -ne 2 ]; then
  echo "Usage: $0 <nom_du_site> <dossier_racine>" >&2
  exit 1
fi

SITE_NAME=$1
ROOT_DIR=$2
CONFIG_FILE="/etc/apache2/sites-available/$SITE_NAME.conf"

# Créer le répertoire racine du site si nécessaire
if [ ! -d "$ROOT_DIR" ]; then
  mkdir -p "$ROOT_DIR"
  echo "<html><body><h1>$SITE_NAME fonctionne!</h1></body></html>" > "$ROOT_DIR/index.html"
fi

# Créer le fichier de configuration Apache pour le site
cat << EOF > $CONFIG_FILE
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $SITE_NAME
    DocumentRoot $ROOT_DIR

    <Directory $ROOT_DIR>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$SITE_NAME-error.log
    CustomLog \${APACHE_LOG_DIR}/$SITE_NAME-access.log combined
</VirtualHost>
EOF

# Activer le site
a2ensite $SITE_NAME.conf

# Vérifier la configuration Apache
apache2ctl configtest

# Redémarrer Apache
service apache2 restart

echo "Le site $SITE_NAME a été configuré et activé avec succès."
