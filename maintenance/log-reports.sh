#!/bin/bash

echo "Starting log reports script."

# Needed for npm context
. "${HOME}/.bash_profile"

echo "Version of npm:"
echo $(npm -v)

cd /home/nomercy235/projects/log-reports
npm start
