
if [ "$(who | grep maqplc | wc -l)" == "1" ]
then
	mpd --kill
fi
