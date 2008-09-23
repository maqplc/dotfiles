#!/bin/sh

progs="xarchiver feh mplayer rxvt-unicode evince thunar firefox snownews sudo gvim ncmpc mpc mpd dzen2 texlive-core nvidia xorg codecs flashplugin alsa-utils hal fam netcfg fakeroot pkgconfig gcstar wine abs"


user="maqplc"
daemons="@net-profiles alsa hal fam"

#Couleurs et pretty print
green="\033[32m"
magenta="\033[35m"
red="\033[31m"
bold="\033[1m"
normal="\033[0m"

#Fonctions
net_connect() {
	net_profile="wifiHome"
	net_dir="/etc/network.d"
	
	echo -e "Copie du profil $bold $net_profile $normal dans le dossier $bold $net_dir $normal."
	
	cp $net_profile $net_dir
	netcfg2 wifiHome
}

daemons_update() {
	sed 's/\(DAEMONS=([^)]*\))/\1 '$daemons')/' /etc/rc.conf > rc.back
	
	mv ./rc.back /etc/rc.conf
}

system_update() {
	#pacman -Sy --noconfirm pacman
	pacman -Sy pacman
	resolve_conflict

	pacman -Syu
}

resolve_conflict() {
	echo $(find / -name "*pacnew")
	for new in $(find / -name "*pacnew")
	do
		old=${new%\.pacnew}
		continuer=true
		while $continuer
		do
			echo -e "Action pour le fichier $bold $old $normal :"
			echo -e "${bold}e${normal}diter"
			echo -e "${bold}d${normal}iff"
			
			echo -e "${bold}c${normal}onserver"
			echo -e "${bold}r${normal}emplacer"
			
			read -n 1 choice
			
			if [ "$choice" == "e" ] ; then vi $old ; fi
			if [ "$choice" == "d" ] ; then diff $old $new | less ; fi

			if [ "$choice" == "c" ] ; then rm $new ; continuer=false ; fi
			if [ "$choice" == "r" ] ; then mv $new $old ; continuer=false ; fi

		done
	done
}

#0) Activer l'internet
net_connect

#1) Mettre à jour le système
system_update
resolve_conflict

#2) Installer les programmes
pacman -S $progs

#3) Mettre à jour le rc.conf
daemons_update

#4) Créer l'utilisateur
useradd -m -G disk,lp,wheel,mail,log,games,network,video,audio,optical,floppy,power $user

passwd $user 
tar -C "/home/$user" -xvf user.tar
chown -R $user:$user "/home/$user"
chmod -R 600 "/home/$user/"

#5) Commandes supplémentaires
alsamixer ; alsactl store
locale-gen
visudo
abs
xorgcfg


echo "Xmonad recompilation"
echo "run.sh"
echo "Conky reinstall"
echo "Reboot"

