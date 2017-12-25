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
		if $withDocker; then
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

update "Trying to update Ask Around API." "/home/nomercy235/projects/ask-around-api" true

update "Trying to update Log Reports." "/home/nomercy235/projects/log-reports" false

exit 0
