#!/bin/bash

echo "Starting script."

# Activate node
. /root/.nvm/nvm.sh
nvm use stable

cd /home/nomercy235/projects/log-reports
npm start
