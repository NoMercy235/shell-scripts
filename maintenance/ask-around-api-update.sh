#!/bin/bash

currDate=`date +"%Y-%m-%d %T"`

# Go to the project directory.
cd /home/nomercy235/projects/ask-around-api

# Get latest version of the project.
git pull origin master

echo "${currDate}: Ask Around API has been updated to the latest version."
exit 0
