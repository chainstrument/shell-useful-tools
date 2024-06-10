# Création d'un utilisateur + permission sudo
# sh create_user_sudo.sh username

# Vérification des arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Assignation de l'argument à une variable
USERNAME=$1

# Création de l'utilisateur
sudo adduser $USERNAME

# Ajout de l'utilisateur au groupe sudo
sudo usermod -aG sudo $USERNAME


# Ajout de l'utilisateur à la ligne AllowUsers dans le fichier sshd_config
sudo sed -i "/^AllowUsers/ s/$/ $USERNAME/" /etc/ssh/sshd_config

# Redémarrage du service ssh + sshd
sudo service ssh restart
sudo service sshd restart


echo "L'utilisateur $USERNAME a été créé avec succès et ajouté au groupe sudo."
