function menu()

{

clear

echo –e " \n\t******MENU ******\n "

echo –e " \n \t 1) Uid user "

echo –e " \n\t 2) Heure de connexion "

echo –e " \n\t 3) Quitter "

echo –e –n " \t\t Entrer votre choix: "

}

function verif_user()

{

us=$1

if `who | grep "^$us " > /dev/null`

then uid=`grep "^$us:" /etc/passwd | awk -F: { print $3 }`

else uid=-1

fi

#Ici la variable uid contiendra le uid du user sinon -1 mais uid variable globale

}

function heure_connexion()

{

us=$1

who | grep "^$us " | awk ‘{ print " Heure_Connexion: " , $4 } ’

}

#Début du script

clear

while true ; do

menu ; uid=0; read choix

case $choix in

1) read –p " Entrer un nom de user: " user

verif_user $user

test $uid –ge 0 && echo " UID de $user= $uid " && sleep 2 && continue

echo " User $user non connecté ";;

2) read –p " Entrer un nom de user: " user

verif_user $user

test $uid –ge 0 && heure_connexion $user && sleep 2 && continue

echo " User $user non connecté ";;

3) echo " Fin du script " ; exit 0 ;;

*) echo " Choix erronné " ;;

esac

sleep 2

done
