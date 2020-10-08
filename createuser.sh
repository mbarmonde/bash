#!/bin/bash

	while [ x$username = "x" ]; do
		read -p "Please enter the username you wish to create : " username
			if id -u $username >/dev/null 2>&1; then
				echo "User already exists"
				username=""
			fi
	done

	while [ x$group = "x" ]; do
		read -p "Please enter the primary group. If the group does not exist, it will be created : " group
			if id -g $group >/dev/null 2>&1; then
				echo "Group already exists or nothing was input"
				else
					groupadd $group
			fi
	done

		read -p "Please enter bash (or hit enter to accept default values) [/bin/bash] : " bash
			if [ x"$bash" = "x" ]; then
				bash="/bin/bash"
			fi

		read -p "Please enter homedir (or hit enter to accept default values) [/home/$username] : " homedir
			if [ x"$homedir" = "x" ]; then
				homedir="/home/$username"
			fi

		read -p "Please confirm [y/n] to add the user to the group, and create the home directory (no will exit this script) : " confirm
			if [ "$confirm" = "y" ]; then
				useradd -g $group -s $bash -d $homedir -m $username
					else
						exit
			fi
			
		read -p "Please create [y/n] an initial password for this new user (no will exit this script and you must change the password manually) : " confirm2
			if [ "$confirm2" = "y" ]; then
				passwd $username
			fi	
			
		read -p "Please create [y/n] a password for root to ensure you can switch users (no will exit this script and you must change the password manually) : " confirm3
			if [ x"$confirm3" = "y" ]; then
				passwd root
			fi	
