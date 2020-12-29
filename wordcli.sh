#!/bin/bash

#####################################################
### WordCLI Project
###
### Copyright: João Pedro [2020]
#####################################################


CLI_HOME="/home/$(whoami)/.wordcli/"
CLI_VERSION="1.0.0"

XAMPP_HOME="/opt/lampp/"
XAMPP_EXECUTABLE="${XAMPP_HOME}lampp"

WORDPRESS_DOWNLOAD_FILE="/tmp/wordpress_latest.tar.gz"
WORDPRESS_INSTALLATION_FOLDER="${CLI_HOME}wordpress"


# Creates the client home folder if it does not exist
if [[ ! -d $CLI_HOME ]]; then
	mkdir $CLI_HOME
fi

function print_header {
	# Printing header
	echo " _    _               _   _____  _     _____ "
	echo "| |  | |             | | /  __ \| |   |_   _|"
	echo "| |  | | ___  _ __ __| | | /  \/| |     | |  "
	echo "| |/\| |/ _ \| '__/ _\` | | |    | |     | |  "
	echo "\\  /\\  / (_) | | | (_| | | \\__/\\| |_____| |_ "
	echo " \\/  \\/ \\___/|_|  \\__,_|  \\____/\\_____/\\___/  for XAMPP"

	echo "  Made by: João Pedro [2020-$(date +%Y)]"
	echo "  Version: $CLI_VERSION"
	echo
	echo

	# Printing options
	echo "Options:"
	echo "  [1] Install wordpress"
	echo "  [2] Create a new wordpress project"
	echo "  [3] Start XAMPP services"
	echo "  [4] Exit"
	echo
}

clear

while [[ 1 == 1 ]]; do
	print_header
	printf "Choose your option: [default: 1] "
	read user_option

	if [[ $user_option -lt 1 || $user_option -gt 4 ]]; then
		echo "Using default option: 1"
		user_option=1
	fi

	# Install/Update wordpress
	if [[ $user_option -eq 1 ]]; then
		if [[ -f $WORDPRESS_DOWNLOAD_FILE ]]; then
			rm $WORDPRESS_DOWNLOAD_FILE
		fi

		clear

		# Downloading
		echo "Downloading latest version of wordpress..."
		echo
		wget "https://wordpress.org/latest.tar.gz" -O $WORDPRESS_DOWNLOAD_FILE

		if [[ -d WORDPRESS_INSTALLATION_FOLDER ]]; then
			echo "Clearing wordpress files..."
			rm -r $WORDPRESS_INSTALLATION_FOLDER
		fi

		# Decompressing
		echo "Wordpress is now being decompressed..."
		echo "Location: $WORDPRESS_INSTALLATION_FOLDER"
		tar -xzvf $WORDPRESS_DOWNLOAD_FILE -C $CLI_HOME

		clear
		echo "Wordpress is now installed on: $WORDPRESS_INSTALLATION_FOLDER"
		echo
		continue
	# Create wordpress project
	elif [[ $user_option -eq 2 ]]; then
		clear
		if [[ ! -d $WORDPRESS_INSTALLATION_FOLDER ]]; then
			echo "Wordpress is not installed. Use the option [1] before proceeding."
			continue
		fi

		echo "Wordpress project creation:"
		echo "[ Files are going to be created on ${XAMPP_HOME}htdocs/ ]"
		echo
		printf "Project name: "
		read project_name

		project_path="${XAMPP_HOME}htdocs/$project_name/"

		echo "Creating project $project_name..."
		sudo cp $WORDPRESS_INSTALLATION_FOLDER $project_path -r

		sudo chgrp $(whoami) $project_path
		sudo chown $(whoami) $project_path
		sudo chmod a+rwx $project_path

		clear
		echo "Project $project_name created!"
		echo "Location: $project_path"
		echo
		continue
	# Start XAMPP services
	elif [[ $user_option -eq 3 ]]; then
		clear

		# Stops the current apache server
		sudo systemctl stop apache2

		echo "Stoping running XAMPP services..."
		sudo $XAMPP_EXECUTABLE stop

		echo "Starting XAMPP services..."
		sudo $XAMPP_EXECUTABLE start

		clear
		echo "XAMPP services are now runnning:"
		echo
		sudo $XAMPP_EXECUTABLE status
		echo
	# Exit
	elif [[ user_option -eq 4 ]]; then
		exit
	fi
done
