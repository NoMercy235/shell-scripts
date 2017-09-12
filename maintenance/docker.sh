#!/bin/bash

echo "=================================================="
currDate=`date +"%Y-%m-%d %T"`

echo "${currDate}: VPS was restarted. Starting docker containers"

# TODO: cleanup all containers and start them again from a fresh image?
containers=( a994c1652022 )

for container in $containers; do
	docker start $container > /dev/null 
	echo "Started ${container}"
done

# Get all containers which contain the string 'ask-around' in their name.
askAroundCleanUp=$(docker ps -a -f name="ask-around" -q)

# Iterate through all of them and remove them.
for container in ${askAroundCleanUp[@]}; do
	docker stop $container > /dev/null
	docker rm $container > /dev/null
	echo "Cleaned up ${container}"
done

# Go to the project directory.
cd /home/nomercy235/projects/ask-around-api

# Get latest version of the project.
git pull origin master

# Start it using the docker-compose up command and place it in the background.
docker-compose up -d > /dev/null
echo "Started Ask Around API"

echo "${currDate}: All docker containers have been started."
echo "=================================================="
exit 0