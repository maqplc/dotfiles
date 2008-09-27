# .bash_login

#------------------------------
# COLORS
#------------------------------
NONE="\[\033[0m\]"
BK="\[\033[0;30m\]" #Black
EBK="\[\033[1;30m\]"
RD="\[\033[0;31m\]" #Red
ERD="\[\033[1;31m\]"
GR="\[\033[0;32m\]" #Green
EGR="\[\033[1;32m\]"
YW="\[\033[0;33m\]" #Yellow
EYW="\[\033[1;33m\]"
BL="\[\033[0;34m\]" #Blue
EBL="\[\033[1;34m\]"
MG="\[\033[0;35m\]" #Magenta
EMG="\[\033[1;35m\]"
CY="\[\033[0;36m\]" #Cyan
ECY="\[\033[1;36m\]"
WH="\[\033[0;37m\]" #White
EWH="\[\033[1;37m\]"

#------------------------------
# ENVIRONMENT VARIABLES
#------------------------------

# BASH/SUDO COMPLETION

# PROMPT
export PS1="[\u@\h${EBL} \w ${NONE}]# \n> "

# MISC OPTIONS

#------------------------------
# ALIASES
#------------------------------

alias ls="ls --color=auto"

#------------------------------
# FUNCTIONS
#------------------------------
extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)	tar xjvf $1	;;
			*.tar.bz)	tar xjvf $1	;;
			*.tar.gz)	tar xvzf $1	;;
			*.bz2)		bunzip2 $1	;;
			*.rar)		rar x $1	;;
			*.gz)		gunzip $1	;;
			*.tar)		tar xvf $1	;;
			*.zip)		unzip $1	;;
			*)		echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

