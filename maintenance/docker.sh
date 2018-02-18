#!/bin/bash

echo "=================================================="
currDate=`date +"%Y-%m-%d %T"`

echo "${currDate}: VPS was restarted. Starting docker containers"

# TODO: cleanup all containers and start them again from a fresh image?
# containers=( a994c1652022 )
containers=( )

for container in $containers; do
	docker start $container > /dev/null 
	echo "Started ${container}"
done

cleanup () {
	for container in ${cleanUpStmt}; do
		docker stop $container > /dev/null
		docker rm $container > /dev/null
		echo "Cleaned up ${container}"
	done
}

# Start Wordpress site
# Get all related containers
wordpressCleanUp=$(docker ps -a -f name="wordpress" -q)

# Iterate through all of them and remove them.
cleanup $wordpressCleanUp

# Go to the project directory
cd /home/nomercy235/projects/wordpress

# Start with docker-compose up
docker-compose up --build -d > /dev/null
echo "Started wordpress site."


# Start Ask Around API
# Get all containers which contain the string 'ask-around' in their name.
askAroundCleanUp=$(docker ps -a -f name="ask-around" -q)

# Iterate through all of them and remove them.
cleanup $askAroundCleanUp

# Go to the project directory.
cd /home/nomercy235/projects/ask-around-api

# Get latest version of the project.
git pull origin master

# Start it using the docker-compose up command and place it in the background.
docker-compose up --build -d > /dev/null
# /home/nomercy235/shell/maintenance/git-updater.sh
echo "Started Ask Around API"



# Start Ask Around Python API
# Get all containers which contain the string 'ask-around-python' in their name.
askAroundPythonCleanUp=$(docker ps -a -f name="ask-around-python" -q)

# Iterate through all of them and remove them.
cleanup $askAroundPythonCleanUp

# Go to the project directory.
cd /home/nomercy235/projects/ask-around-python/ask-around

# This has to be done manually because the credentials are differnet
# Get latest version of the project.
git pull origin master

# Start it using the docker-compose up command and place it in the background.
docker-compose up --build -d > /dev/null
echo "Started Ask Around Python API"




echo "${currDate}: All docker containers have been started."
echo "=================================================="
exit 0
