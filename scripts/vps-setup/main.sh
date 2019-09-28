#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "Please run as sudo user"
  exit
fi

cwd=$(dirname "$0")
mainUser=$1
. "${cwd}/utils.sh"

echoTitle "Checking main user: ${mainUser}"
userExists=$(grep -c "^${mainUser}:" /etc/passwd)
if [ ! -z "$userExists" ]; then
  useradd -m "$mainUser"
  echo "User created"
else
  echo "User already exists"
fi


apt-get update -y && apt-get upgrade -y

eval "${cwd}/install-dependencies.sh $mainUser"
eval "${cwd}/generate-ssh-key.sh $mainUser"
"${cwd}/setup-projects.sh"
