#!/bin/bash

# sh search_string.sh chaine_de_caractere_a_rechercher

# Vérifier les paramètres
if [ $# -ne 1 ]; then
  echo "Usage: $0 <chaine_de_caractere_a_rechercher>" >&1
  exit 1
fi


# Variables
SEARCH_DIRS="
  /home/amine/script
  /home/amine/test
  /home/amine/project
"
SEARCH_STRING=$1
LOG_FILE="logs/log_$(date +%Y%m%d).txt"

mkdir -p logs 
# Rechercher la chaîne de caractères
for DIR in $SEARCH_DIRS; do
  grep -r $SEARCH_STRING "$DIR" >> "$LOG_FILE"
done