#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "Please run as sudo user"
  exit
fi

cwd=$(dirname "$0")

apt-get update -y && apt-get upgrade -y

"${cwd}/install-dependencies.sh"
"${cwd}/generate-ssh-key.sh"
"${cwd}/setup-projects.sh"
