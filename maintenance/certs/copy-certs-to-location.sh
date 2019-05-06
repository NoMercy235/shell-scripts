#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

domain=${1}
path=${2}
mode=${3:-"775"}

cp -RL --remove-destination -m $mode "/etc/letsencrypt/live/${domain}/." $path

echo "Certs for domain ${domain} copied to ${path}"

exit 0

