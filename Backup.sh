#!/bin/sh

# Ce script crée un dossier de sauvegarde avec tar
echo "Ce script crée un dossier de sauvegarde avec tar."

# Définir les constantes
BACKUPDIR="/Backup"
TIMESTAMP="timestamps.dat"
SOURCE="/home"

# Créer le dossier de sauvegarde s'il n'existe pas
mkdir -p ${BACKUPDIR}

# Récupérer le dernier numéro de sauvegarde
lastname=$(ls ${BACKUPDIR}/backup-??.tar.gz 2>/dev/null | sort | tail -n 1)
bkpnr=${lastname##*backup-}
bkpnr=${bkpnr%%.*}

# Si c'est la première sauvegarde, attribuer le numéro 0
if [ -z "$bkpnr" ]; then
  bkpnr=0
fi

# Convertir en entier et incrémenter de 1
bkpnr=$((${bkpnr#0} + 1))

# Si plus de 4 semaines de sauvegarde, faire une rotation des dossiers et réinitialiser le numéro de sauvegarde à 1
if [ $bkpnr -gt 28 ]; then
  DATE=$(date +%Y-%m-%d)
  mkdir -p ${BACKUPDIR}/${DATE}
  mv ${BACKUPDIR}/backup-*.tar.gz ${BACKUPDIR}/${DATE}
  mv ${BACKUPDIR}/${TIMESTAMP} ${BACKUPDIR}/${DATE}
  bkpnr=1
fi

# Si le numéro de sauvegarde est de 1 chiffre, ajouter un 0 devant
if [ ${#bkpnr} -eq 1 ]; then
  bkpnr=0$bkpnr
fi

# Créer le nom du fichier de sauvegarde
filename=backup-${bkpnr}.tar.gz

# Créer le fichier de sauvegarde
tar -cpzf ${BACKUPDIR}/${filename} -g ${BACKUPDIR}/${TIMESTAMP} ${SOURCE}
echo "Sauvegarde créée: ${BACKUPDIR}/${filename}"
