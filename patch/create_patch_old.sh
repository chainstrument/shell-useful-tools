# sh  create_patch_old.sh 

# Path du patch à appliquer
S186_DIR="/home/amine/project/s186/"
# Path du dossier du projet
S186_PROJECT_DIR="/home/amine/project/s186-Warranty_Force_Glass/"
# Path du dossier patch_old
PATCH_OLD_DIR="/home/amine/project/patch_old/"

# Vérifier si les dossiers existent
if [ ! -d "$S186_DIR" ]; then
    echo "Le dossier n'existe pas."
    exit 1
fi

# Vérifier si les dossiers existent
if [ ! -d "$S186_PROJECT_DIR" ]; then
    echo "Le dossier du projet n'existe pas."
    exit 1
fi


mkdir -p patch_old


# Créer un dossier patch_old
if [ -d "patch_old" ]; then
    rm -rf patch_old
    mkdir -p patch_old
fi




find "$S186_DIR" -mindepth 1 -type f -printf '%P\n' | while IFS= read -r file; do
  # Extraire le chemin relatif du fichier
  file_path=$(dirname "$file")
  # Créer le dossier de destination s'il n'existe pas encore
  mkdir -p "$PATCH_OLD_DIR/$file_path"
  # Copier le fichier vers le bon dossier dans patch_old
  cp "$S186_PROJECT_DIR/$file" "$PATCH_OLD_DIR/$file_path/"
done

echo "Copie des fichiers modifiés terminée."
