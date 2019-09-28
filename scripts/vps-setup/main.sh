#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "Please run as sudo user"
  exit
fi

apt-get update -y && apt-get upgrade -y

./install-dependencies.sh
./generate-ssh-key.sh
./setup-projects.sh