#!/bin/bash

me=$(whoami)
cwd=$(dirname "$0")
mainUser=$1

. "${cwd}/utils.sh"

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

echoTitle "Installing basic dependinces"
checkDependency "ssh-keygen" "apt-get install -y openssh-client"
checkDependency "git" "apt-get install -y git"
checkDependency "nano" "apt-get install -y nano"
checkDependency "curl" "apt-get install -y curl"
checkDependency "sudo" "apt-get install -y sudo"

echoTitle "Installing Docker"
checkDependency "docker" "${cwd}/../get-docker.sh && usermod -aG docker ${mainUser}"

# Install Oh My Zsh
echoTitle "Installing Oh My Zsh"
checkDependency "zsh" "apt-get install -y zsh"
ohMyZshDir="${HOME}/.zshrc"
if [ ! -f "$ohMyZshDir" ]; then
  echo "Installing zsh"
  RUNZSH=no yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Install Nvm for root and main user
echoTitle "Install NVM for root"
nvmInstallCommand="curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash"
checkDependency "nvm" "$nvmInstallCommand"
echoTitle "Install NVM for user: ${mainUser}"
checkNvmForUser=$(runForUser "$mainUser" "nvm")
installNvmForUser=$(runForUser "$mainUser" "$nvmInstallCommand")
checkDependency "$checkNvmForUser" "$installNvmForUser"

# Setup crontab
echoTitle "Installing crontab and setting up cron jobs"
crontabFilePath="${cwd}/../../utils/crontab"
checkDependency "crontab" "apt-get install -y cron"
crontab "$crontabFilePath"
