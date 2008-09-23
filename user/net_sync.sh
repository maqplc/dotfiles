#!/bin/sh

green="\033[32m"
magenta="\033[35m"
red="\033[31m"
bold="\033[1m"
normal="\033[0m"

function Folder_explore {
	for current in *.get
	do
		( . $current )
	done
}

function Feed_updated {
	if [ 4 == $# ]
	then
		echo -n "Do you want to update $1 [y/*] ? "
		read -n 1 choice

		if [ ! "$choice" == "y" ] ; then exit 0 ; fi

		feed_name=$1".feed"
		echo -e "Checking feed $bold $1 $normal"

		if [ ! -d "$1" ]
		then
			echo "Creating repository"
			mkdir "$1"
		fi

		if [ -f "$feed_name" ]
		then
			echo -e "Checking for updates $bold($1) $normal"
			wget -nv $2 -O "$1.new"

			if cmp -s "$feed_name" "$1.new"
			then
				mv "$1.new" "$feed_name"
				echo -e "$1 $green up to date $normal"
			else
				mv "$1.new" "$feed_name"
				echo -e "$1 needs to be $red updated $normal"
				cd "$1" ; eval $4 ; cd ..
			fi

		else
			echo "New feed, fetching $2"
			wget -nv $2 -O "$feed_name"
			cd "$1" ; eval $3 ; cd ..

		fi
	fi
}

for folder in $(find ./ -name "*get" | sed 's/\/\([^\/]*\.get\)//' | sort -u)
do
	pushd ./

	cd "$folder"
	Folder_explore

	popd
done
