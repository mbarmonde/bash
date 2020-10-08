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
			if [ "$confirm3" = "y" ]; then
				passwd root
			fi	
		
		read -p "To initiate this user for a Teradici PCoIP container choose 'y', otherwise to complete the script choose 'n': " confirm4
			if [ "$confirm4" = "n" ]; then
				exit
				else
				# The following was derived from this link: https://www.teradici.com/web-help/pcoip_client/linux/20.10/reference/creating_a_docker_container/
					# Setup a functional user within the docker container with the same permissions as your local user.
					export uid=1000 gid=1000 && \
						mkdir -p /etc/sudoers.d/ && \
						mkdir -p /home/$username && \
						echo "$username:x:${uid}:${gid}:$username,,,:/home/$username:/bin/bash" >> /etc/passwd && \
						echo "$username:x:${uid}:" >> /etc/group && \
						echo "$username ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$username && \
						chmod 0440 /etc/sudoers.d/$username && \
						chown ${uid}:${gid} -R /home/$username
						
					# Set some Docker environment variables for the current user
					USER myuser
					ENV HOME /home/myuser
					
					# Set the Docker path for QT to find the keyboard context
					ENV QT_XKB_CONFIG_ROOT /user/share/X11/xkb
					ENTRYPOINT exec pcoip-client
			fi
