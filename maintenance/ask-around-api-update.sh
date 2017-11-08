#!/bin/bash

currDate=`date +"%Y-%m-%d %T"`

# Go to the project directory.
cd /home/nomercy235/projects/ask-around-api

# Get latest version of the project.
pullResult=$(git pull origin master)

if [[ $pullResult != *"Already\ up-to-date."* ]]; then
	echo "Update has been detected. Rebuilding app..."
	docker-compose down > /dev/null
	docker-compose build > /dev/null
	docker-compose up > /dev/null
fi

echo "${currDate}: Ask Around API has been updated to the latest version."
exit 0
