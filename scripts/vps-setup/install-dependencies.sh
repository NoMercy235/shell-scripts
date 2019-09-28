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
checkDependency "nano" "apt-get install -y nano"
checkDependency "curl" "apt-get install -y curl"
checkDependency "sudo" "apt-get install -y sudo"
checkDependency "docker" "../get-docker.sh && usermod -aG docker ${me}"

# Install Oh My Zsh
checkDependency "zsh" "apt-get install -y zsh"
ohMyZshDir="${HOME}/.zshrc"
if [ ! -f "$ohMyZshDir" ]; then
  echo "Installing zsh"
  RUNZSH=no yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Setup crontab
crontabFilePath="${PWD}/../../utils/crontab"
checkDependency "crontab" "apt-get install -y cron"
crontab "$crontabFilePath"
