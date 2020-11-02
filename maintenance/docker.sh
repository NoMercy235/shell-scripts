#!/bin/bash

echo "=================================================="
currDate=`date +"%Y-%m-%d %T"`

echo "${currDate}: VPS was restarted. Starting docker containers"

# Needed for npm context
. "${HOME}/.bash_profile"

# TODO: cleanup all containers and start them again from a fresh image?
# containers=( a994c1652022 )
containers=( )

for container in $containers; do
	docker start $container > /dev/null 
	echo "Started ${container}"
done

cleanup () {
	# Get all related containers
	cleanUpStmt=$(docker ps -a -f name="$1" -q)

	# Iterate through all of them and remove them.
	for container in ${cleanUpStmt}; do
		docker container stop $container > /dev/null
		docker container rm $container > /dev/null
		echo "Cleaned up ${container}"
	done
}

# Start Wordpress site
echo "Wordpress site"

# Execute cleanup
cleanup "^/wordpress$"

# Go to the project directory
# cd /home/nomercy235/projects/wordpress

# Start with docker-compose up
# docker-compose up --build -d > /dev/null
# echo "Started wordpress site."
echo "Deprecated - no longer starting this one."
echo "................................................"


# Start Ask Around API
# echo "Ask Around API"

# Cleanup
# cleanup "^/ask-around$"

# Go to the project directory.
# cd /home/nomercy235/projects/ask-around-api

# Get latest version of the project.
# git pull origin master

# Start it using the docker-compose up command and place it in the background.
# docker-compose up --build -d > /dev/null
# /home/nomercy235/shell/maintenance/git-updater.sh
# echo "Started Ask Around API"
# echo "................................................"


# Start Ask Around Python API
echo "Ask Around Python API"

# Cleanup
cleanup "^/ask-around-python$"

# Go to the project directory.
projectDir=/home/nomercy235/projects/ask-around-python/ask-around
cd $projectDir

# This has to be done manually because the credentials are differnet
# Get latest version of the project.
echo "Can't get the last changes from git due to need for credentials."
echo "Please run 'git pull origin master' in '${projectDir}' to update."
# git pull origin master

# Start it using the docker-compose up command and place it in the background.
docker-compose down
docker-compose up --build -d
echo "Started Ask Around Python API"

# Start Employee Management
# echo "Employee Management"

# Cleanup
# cleanup "^/employee-management$"

# Go to the project directory.
# projectDir=/home/nomercy235/projects/employee-management
# cd $projectDir

# Get latest version of the project.
# git pull origin master

# Build the application
# npm run build

# Start it using the docker-compose up command and place it in the background.
# docker-compose up --build -d > /dev/null
# /home/nomercy235/shell/maintenance/git-updater.sh
# echo "Started Employee Management"
# echo "................................................"

# Start Rigamo
echo "Starting Rigamo"

cleanup "^/rigamo-backend"
cleanup "^/rigamo-frontend"

rigamoBasePath=/home/nomercy235/projects/cyoa

echo "Starting Backend"
cd "${rigamoBasePath}/cyoa-backend"
git pull origin master
docker-compose down
docker-compose up --build -d

echo "Starting frontend"
cd "${rigamoBasePath}/cyoa-frontend"
git pull origin master
docker-compose down
docker-compose up --build -d

echo "Finished starting Rigamo"
echo "=================================================="

currDate=`date +"%Y-%m-%d %T"`
echo "${currDate}: All docker containers have been started."
echo "=================================================="
exit 0
