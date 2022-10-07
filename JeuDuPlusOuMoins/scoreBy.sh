#!/bin/bash
file="./classement.txt"

# shellcheck source=/dev/null
source app.conf

echo "Pour trouver le score d'un joueur, tappez simplement son nom "
read -r joueur

if grep -q "${joueur}" ${file};
then
    joueur=$(grep "${joueur}" ${file})
    echo "${joueur}"
else
    echo "Joueur inexistant "
fi