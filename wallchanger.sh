#!/bin/bash

# EXPORT BUS ADDRESS IS REQUIRED FOR GSETTINGS IN CRON
OS=$(lsb_release -si)
if [ "$OS" == 'Arch' ]
then
	echo "Archlinux detected"
	export $(cat /proc/$(pgrep -u `whoami` ^gnome-shell$)/environ | grep -z DBUS_SESSION_BUS_ADDRESS)
elif [ "$OS" == "Ubunutu" ]
then
	PID=$(pgrep gnome-session)
	export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(PID)/environ|cut -d= -f2-)
else
	echo "Your distribution is not supported yet !"
fi

# CONFIGURATION
HOME="/home/flow"
WALLPAPERS_PATH="$HOME/Pictures/Wallpapers"

echo "WALLPAPERS PATH : $WALLPAPERS_PATH"

# NOMBRE DE FICHIERS DANS LE REPERTOIRE
FILE_COUNT=$(find $WALLPAPERS_PATH -type f | wc -l)
echo "Number of files : $FILE_COUNT"

# CREATE WALLPAERS HISTORY IF NOT EXIST
HIST_FILE="$HOME/.wallchanger/wallpapers-history"

# IF THE HISTORY FILE HAS BEEN DELETE. WE CREATE IT
if [ ! -f "$HIST_FILE" ]; then
	touch "$HIST_FILE"
fi

I=0
for H in $(cat "$HIST_FILE"); do
    HIST_LIST[$I]="$H"
    I=$(expr $I + 1)
done

file=$(find $WALLPAPERS_PATH -type f | shuf -n 1)
while [[ " ${HIST_LIST[*]} " == *" $file "* ]]
do
	file=$(find $WALLPAPERS_PATH -type f | shuf -n 1)
done

echo "WALLPAPER TO LOAD : $file"

DISPLAY=:0
GSETTINGS_BACKEND=dconf

gsettings set org.gnome.desktop.background picture-uri "$file"
gsettings set org.gnome.desktop.background picture-options zoom

echo "HISTORY COUNT : $(expr $I + 1)"
echo "TOTAL COUNT   : $FILE_COUNT"

if [ "$(expr $I + 1)" = "$FILE_COUNT" ]
then
	echo "ALL WALLPAPER USED > REMOVE HISTORY"
	rm "$HIST_FILE"
else
	echo "ADD CURRENT WALLPAPER TO HISTORY"
	echo "$file" >> "$HIST_FILE"
fi

echo ""
echo " -- "
echo ""
