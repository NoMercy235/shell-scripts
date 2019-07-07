#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

domain=${1}
path=${2}

cp -RL --remove-destination "/etc/letsencrypt/live/${domain}/." $path
chown -R nomercy235 $path

echo "Certs for domain ${domain} copied to ${path}"

exit 0

