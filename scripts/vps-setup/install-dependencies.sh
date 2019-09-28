#!/bin/bash

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