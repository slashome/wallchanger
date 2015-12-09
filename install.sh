#!/bin/bash
install_Arch() {
	echo "Install Wallchanger Daemon for Archlinux"
}

install_Ubuntu() {
	if [ -f "/etc/init.d/wallchanger" ]
	then
		echo "Remove existing Daemon"
		sudo rm "/etc/init.d/wallchanger"
	fi
	sudo cp "$HOME/.wallchanger/daemons/ubuntu_daemon" "/etc/init.d/wallchanger"
	sudo chmod 0755 "/etc/init.d/wallchanger"
}

OS=$(lsb_release -si)

if [ "`type -t install_$OS`" = 'function' ]
then
	install_$OS
else
	echo 'Your distribution is not handled by this installator, you can read the script and install it yourself ;)'
fi

exit

# THIS SCRIPT WILL AUTO DESTRUCT IN 0 SECONDS !
rm -- "$0"
