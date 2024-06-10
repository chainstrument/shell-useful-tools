#!/bin/bash

# sh notification_discord.sh message

# Vérifier les paramètres
if [ $# -ne 1 ]; then
  echo "Usage: $0 <message>" >&2
  exit 1
fi

# Variables
WEBHOOK_URL="url"
MESSAGE=$1

# Envoyer la notification
curl -H "Content-Type: application/json" -d "{
  \"content\": \"$MESSAGE\"
}" $WEBHOOK_URL
