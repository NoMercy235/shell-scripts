#!/bin/bash

me=$(whoami)

function checkDependency {
  commandToCheck=$1
  install=$2

  exists=$(command -v "$commandToCheck")
  if [[ -z "$exists" ]]; then
    eval "$install"
  else
    echo "Dependency for command (${commandToCheck}) already exists"
  fi
}

checkDependency "ssh-keygen" "apt-get install -y openssh-client"
checkDependency "git" "apt-get install -y git"
checkDependency "curl" "apt-get install -y curl"
checkDependency "sudo" "apt-get install -y sudo"
checkDependency "docker" "../get-docker.sh && usermod -aG docker ${me}"