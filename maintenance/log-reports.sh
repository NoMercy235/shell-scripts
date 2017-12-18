#!/bin/bash

echo "Starting script."

# Activate node
# /home/nomercy235/shell/maintenance/activate-node.sh
. /root/.nvm/nvm.sh
nvm use stable

cd /home/nomercy235/projects/log-reports
npm start
