#!/bin/bash

W="\\033[0;39m"
R="\\033[1;31m"
G="\\033[1;32m"
B="\\033[1;34m"

pre_install()
{
	if [ -d "$HOME/.wallchanger" ]
	then
		# TODO : Save configuration file
		echo -e "$R Remove existing installation $W"
		sudo rm -r "$HOME/.wallchanger"
	fi
	cd $HOME
	echo -e "$G Cloning lastest version $W"
	git clone https://github.com/ziltoidtheomiscient/wallchanger.git .wallchanger
	cd .wallchanger
	mv .wallchangerrc ..
	rm install.sh
}

install_Arch()
{
	pre_install
	echo "Install Wallchanger Daemon for Archlinux"
	post_install
}

install_Ubuntu()
{
	pre_install
	if [ -f "/etc/init.d/wallchanger" ]
	then
		echo -e "$G Remove existing Daemon $W"
		sudo rm "/etc/init.d/wallchanger"
	fi
	sed -i -e "s/_username_/$USER/g" $HOME/.wallchanger/daemons/ubuntu_daemon
	sudo cp "$HOME/.wallchanger/daemons/ubuntu_daemon" "/etc/init.d/wallchanger"
	sudo chmod 0755 "/etc/init.d/wallchanger"
	post_install
}

post_install()
{
	cd $HOME/.wallchanger
	sudo rm -r daemons
}


OS=$(lsb_release -si)
if [ "`type -t install_$OS`" = 'function' ]
then
	install_$OS
else
	echo -e "$R Your distribution is not handled by this installator, you can read the script and install it yourself ;) $W"
fi

exit

# THIS SCRIPT WILL AUTO DESTRUCT IN 0 SECONDS !
rm -- "$0"

