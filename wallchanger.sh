#!/bin/bash

# config
CFG_FILE="$HOME/.wallchanger/wallchanger.cfg"
. "$CFG_FILE"

# Export BUS address is required for gsettings in cron
PID=$(pgrep gnome-session)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)

#nombre de fichiers dans le répertoire
FILE_COUNT=$(find $WALLPAPERS_PATH/* | wc -l)
echo "Number of files : $FILE_COUNT"

# create wallpapers history if not exist
HIST_FILE="./wallpapers-hitory"

# If the history file has been delete, we create it
if [ ! -f "$HIST_FILE" ]; then
	touch "$HIST_FILE"
fi

I=0
for H in $(cat "$HIST_FILE"); do
    HIST_LIST[$I]="$H"
    I=$(expr $I + 1)
done

file=$(find $WALLPAPERS_PATH/* | shuf -n 1)
while [[ " ${HIST_LIST[*]} " == *" $file "* ]]
do
	file=$(find $WALLPAPERS_PATH/* | shuf -n 1)
done

echo $file

# echo $file
gsettings set org.gnome.desktop.background picture-uri "$file"
gsettings set org.gnome.desktop.background picture-options zoom

echo "$(expr $I + 1)"
echo "$FILE_COUNT"

if [ "$(expr $I + 1)" = "$FILE_COUNT" ]
then
	rm "$HIST_FILE"
else
	echo "$file" >> "$HIST_FILE"
fi
