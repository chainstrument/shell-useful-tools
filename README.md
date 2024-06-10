# shell-useful-tools

Execution des scripts :

1. Dans le dossier Alet

Création d'un utilisateur avec les droit sudo: 
```shell
sh create_user_sudo.sh <username>
```

Envoi d'une notification teams/discord : 
```shell
sh notification_discord.sh <message>

sh notification_teams.sh <message>
```

Recherche d'un chaîne de caractère dans plusieurs dossiers : 
```shell
sh search_string.sh <string> 
```

2. Dans le dossier Apache

Ajout d'un site sur apache : 
```shell
sh add_apache_site.sh <domain> <dossier_racine>
```

Ajout d'un ssl sur apache : 
```shell
sh add_ssl_site.sh <nom_domain.com> <email>
```

Renouvellemnt ssl  : 
```shell
sh renew_ssl.sh 
```

3. Dans le dossier patch

Créer un patch du projet existant : 
```shell
sh create_patch_old.sh
```