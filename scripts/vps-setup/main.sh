#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "Please run as sudo user"
  exit
fi

cwd=$(dirname "$0")
mainUser=$1

apt-get update -y && apt-get upgrade -y

eval "${cwd}/install-dependencies.sh $mainUser"
eval "${cwd}/generate-ssh-key.sh $mainUser"
"${cwd}/setup-projects.sh"
