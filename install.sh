#!/bin/bash

W="\\033[0;39m"
R="\\033[1;31m"
G="\\033[1;32m"
B="\\033[1;34m"

pre_install()
{
	if [ -d "$HOME/.wallchanger" ]
	then
		echo -e "$R -> Remove existing installation $W"
		sudo rm -r $HOME/.wallchanger
	fi
	cd $HOME
	echo -e "$G -> Cloning lastest version $W"
	git clone https://github.com/ziltoidtheomiscient/wallchanger.git .wallchanger

	if [ ! -f "$HOME/.wallchangerrc" ]
	then
		echo -e "$G -> No configuration file found, copy the default one $W"
		mv $HOME/.wallchanger/.wallchangerrc $HOME
		rm install.sh
		echo -e "$B -> Please edit the configuration file : $W"
		$EDITOR $HOME/.wallchangerrc
	else
		echo -e "$G -> Keeping existing configuration file $W"
	fi
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
		echo -e "$R -> Remove existing Daemon $W"
		sudo /etc/init.d/wallchanger stop
		sudo update-rc.d -f wallchanger remove
		sudo rm /etc/init.d/wallchanger
		echo ""
	fi
	sed -i -e "s/_username_/$USER/g" $HOME/.wallchanger/daemons/ubuntu_daemon
	sed -i -e "s/_userhome_/$HOME/g" $HOME/.wallchanger/daemons/ubuntu_daemon
	sudo cp "$HOME/.wallchanger/daemons/ubuntu_daemon" "/etc/init.d/wallchanger"
	sudo chmod 0755 /etc/init.d/wallchanger
	echo -e "$G -> Registering wallchanger service $W"
	sudo update-rc.d wallchanger defaults
	echo -e "$G -> Starting the daemon $W"
	sudo /etc/init.d/wallchanger start
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
	echo -e "$R -> Your distribution is not handled by this installator, you can read the script and install it yourself ;) $W"
fi

exit

# THIS SCRIPT WILL AUTO DESTRUCT IN 0 SECONDS !
rm -- "$0"

