#!/bin/bash

update () {
	message=$1
	path=$2
	withDocker=$3

	# Print the message.
	echo $message

	# Go to the designated path.
	cd $path

	# Make sure that the local changes are discared.
	git reset --hard &> /dev/null

	pullResult=$(git pull origin master)

	if [[ $pullResult != *Already\ up-to-date.* ]]; then
		echo "Update has been detected."
		if [[ $withDocker ]]; then
		        docker-compose down > /dev/null
	       		docker-compose build > /dev/null
		        docker-compose up > /dev/null
		fi
	else
		echo "No update detected."
	fi
	currDate=`date +"%Y-%m-%d %T"`
	echo "${currDate}: Finished."
}

# currDate=`date +"%Y-%m-%d %T"`

update "Trying to update Ask Around API." "/home/nomercy235/projects/ask-around-api" True

update "Trying to update Log Reports." "/home/nomercy235/projects/log-reports" False


#echo "Trying to update Ask Around API."

# Go to the project directory.
#cd /home/nomercy235/projects/ask-around-api

# Make sure that the local changes are discared.
#git reset --hard > /dev/null

# Get latest version of the project.
#pullResult=$(git pull origin master)

#if [[ $pullResult != *Already\ up-to-date.* ]]; then
#	echo "Update has been detected. Rebuilding app..."
#	docker-compose down > /dev/null
#	docker-compose build > /dev/null
#	docker-compose up > /dev/null
#	echo "${currDate}: Ask Around API has been updated to the latest version."
#else
#	echo "No update detected."
#fi

exit 0
