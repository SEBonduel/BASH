#!/bin/bash
# shellcheck source=/dev/null
source ./app.conf

random=${RANDOM:0:2}
user=0
score=0
username=''
fileScores="./tableau_scores.txt"
HighScores="./classement.txt"

echo "choisis un nombre entre 1 et 99"
echo $random
read user

score=$((score+1))
while [ "$user" -ne "$random" ];
do
    if [ "$user" -lt "$random" ];
    then
        echo "plus, rentente !"
        score=$((score+1))
    else
        echo "moins, retente !"
        score=$((score+1))
    fi
    read user
done

if [[ $score -lt "$essaisMax" ]]
then
    echo "Bien joué, le nombre était"
	echo $random
	echo "Votre score est de $score essais. Quel est votre nom?"
	read username
	echo "$username à gagné en $score essais" >> tableau_score.txt 
	cat tableau_score.txt | sort -n -k 5  > classement.txt

    ScoreSend=$(wc -l < ${fileScores})
    if [ "$ScoreSend" -lt "$ScoresMax" ];
    then
        echo "${win} : $score" >> ${fileScores}       
        if grep -q "${win}" ${classement};
        then
            joueur=$(grep "${win}" ${classement})
            coupsJoueur=$(echo "${joueur}" | cut -d ':' -f 2)

            if [ ${score} -lt "${coupsJoueur}" ] && [ "${coupsJoueur}" -gt 0 ]
            then
                echo "Vous venez d'améliorer votre score maximum, bien joué !"
                resultat="${win} : ${score}"
                sed -i -e "s/${joueur}/${resultat}/g" ${classement}
            else
                echo "Retentez votre chance pour améliorer votre score !"
            fi
        else
            echo "${win} : $score" >> ${classement}
            echo "classement établi "
        fi  
    else
        echo "Le nombre de score max enregistrés à été atteint. "
        make reset-scores
    fi
else
    echo "Nombre de coup dépassé, dommage !"
fi