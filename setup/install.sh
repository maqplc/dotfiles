#!/bin/sh

#------------------------------
# COLORS
#------------------------------
green="\033[32m"
magenta="\033[35m"
red="\033[31m"
bold="\033[1m"
normal="\033[0m"

#------------------------------
# VARIABLES
#------------------------------

PROGS="\
	xorg nvidia xmonad xmonad-contrib dzen2 \
	git \
	screen \
	mpc mpd ncmpc \
	feh \
	mplayer codecs \
	rxvt-unicode \
	evince \
	thunar \
	firefox flash-plugin \
	sudo \
	gvim \
	alsa-utils \
	hal \
	fam \
	netcfg \
	abs fakeroot pkgconfig \
	wine \
	unzip unrar bzip2 \
	"
#cdrkit dvd+rw-tools elinks rtorrent
#snownews cmus

user="maqplc"
daemons="@net-profiles alsa hal fam"


#------------------------------
# FUNCTIONS 
#------------------------------

title_display() {
	echo -e "${bold}=>${green} $1 $normal"
}

CONNECT() {
	net_profile="wifiHome"
	net_dir="/etc/network.d"
	
	title_display "Connexion à internet"	
	
	echo -ne "Saisissez l'${bold}ESSID${normal} du réseau cible : "
	read net_ESSID

	echo -ne "Saisissez la ${bold}clé${normal} du réseau cible :"
	read net_KEY

	echo 'ESSID="'$net_ESSID'"' >> $net_profile
	echo 'KEY="'$net_KEY'"' >> $net_profile

	echo -e "Copie du profil $bold $net_profile $normal"
	cp $net_profile $net_dir
	netcfg2 $net_profile
}

UPDATE() {
	title_display "Mise à jour de pacman"

	pacman -Sy pacman
	UNCONFLICT
	
	title_display "Mise à jour des paquets"
	pacman -Syu
}

UNCONFLICT() {
	title_display "Résolution des conflits"

	echo $(find / -name "*pacnew")
	for new in $(find / -name "*pacnew")
	do
		old=${new%\.pacnew}
		continuer=true
		while $continuer
		do
			clear
			title_display "$old <-> $normal"
			echo -e "\t ${bold}E${normal}diter"
			echo -e "\t ${bold}D${normal}iff"
			
			echo -e "\t ${bold}C${normal}onserver l'ancien fichier (supprimer le nouveau)"
			echo -e "\t ${bold}R${normal}emplacer par le nouveau"
			
			read -n 1 choice
			
			if [ "$choice" == "e" ] ; then vi $old ; fi
			if [ "$choice" == "d" ] ; then diff $old $new | less ; fi

			if [ "$choice" == "c" ] ; then rm $new ; continuer=false ; fi
			if [ "$choice" == "r" ] ; then mv $new $old ; continuer=false ; fi

		done
	done
}

POLISH() {
	title_display "Making things better"

	echo "Démons à ajouter : $daemons"
	read insipid_var
	vi /etc/rc.conf

	alsamixer
	alsactl store

	vi /etc/locale.gen
	locale-gen

	visudo

	xorgcfg

	abs
}

USER_CREATE() {
	title_display "Création du compte $user"
	useradd -m -G disk,lp,wheel,mail,log,games,network,video,audio,optical,floppy,power $user
	passwd $user 
}

#------------------------------
# RUNNING
#------------------------------


#UPDATE
#UNCONFLICT

#pacman -S $progs
#USER_CREATE
#POLISH

echo "Ready for some action : CONNECT UPDATE UNCONFLICT USER_CREATE POLISH and PROGS var"
