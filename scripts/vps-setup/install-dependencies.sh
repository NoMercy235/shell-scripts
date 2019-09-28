#!/bin/bash

me=$(whoami)
cwd=$(dirname "$0")
mainUser=$1

function runForUser {
    user=$1
    command=$2
    echo "su -c \"$command\" $user"
}

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
checkDependency "docker" "${cwd}/../get-docker.sh && usermod -aG docker ${me}"

# Install Oh My Zsh
checkDependency "zsh" "apt-get install -y zsh"
ohMyZshDir="${HOME}/.zshrc"
if [ ! -f "$ohMyZshDir" ]; then
  echo "Installing zsh"
  RUNZSH=no yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Install Nvm for root and main user
nvmInstallCommand="curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash"
checkDependency "nvm" "$nvmInstallCommand"
checkNvmForUser=$(runForUser "$mainUser" "nvm")
installNvmForUser=$(runForUser "$mainUser" "$nvmInstallCommand")
checkDependency "$checkNvmForUser" "$installNvmForUser"

# Setup crontab
crontabFilePath="${cwd}/../../utils/crontab"
checkDependency "crontab" "apt-get install -y cron"
crontab "$crontabFilePath"
