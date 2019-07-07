#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

echo ""
echo "Renewing all certs"

# Not needed if we're not doing anything with npm
# source ~/.bash_profile

targetContainer=${1:-"cyoa-frontend"}
stopTarget=
startTarget=

# If there is a target container, it must be restarted
if [[ ! -z $targetContainer ]]; then
  echo "Sunt in if"
  stopTarget="docker container stop ${targetContainer}"
  startTarget="docker container start ${targetContainer}"
fi

pathToCopyCerts="/home/nomercy235/shell/maintenance/certs/copy-certs-to-location.sh www.cyoatta.xyz"
copyCertsToCYOAFrontend="${pathToCopyCerts} /home/nomercy235/projects/cyoa/cyoa-frontend/certs/"
copyCertsToCYOABackend="${pathToCopyCerts} /home/nomercy235/projects/cyoa/cyoa-backend/certs/"

# These should not be used
restartCYOAFrontend="echo 'Restarting CYOA Frontend' && npm run serve --prefix /home/nomercy235/projects/cyoa/cyoa-frontend"
restartCYOABackend="echo 'Restarting CYOA Backend' && npm run serve --prefix /home/nomercy235/projects/cyoa/cyoa-backend"
setupContainers="${restartCYOABackend} && ${restartCYOAFrontend}"

preHook="${stopTarget}"
postHook="${copyCertsToCYOAFrontend} && ${copyCertsToCYOABackend} && docker container start ${targetContainer}"

certbot renew --pre-hook "${preHook}" --post-hook="${postHook}" --dry-run

echo ""
echo "Done renewing"

exit 0

