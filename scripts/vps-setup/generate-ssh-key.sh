#!/bin/bash

cwd=$(dirname "$0")
. "${cwd}/utils.sh"

mainUser=$1
mainUserHome=$(su -c "echo \$HOME" $mainUser)
sshDir="${mainUserHome}/.ssh"

echoTitle "Setting up SSH"
if [ ! -d "$sshDir" ]; then
  eval $(runForUser "$mainUser" "ssh-keygen -f ${sshDir}/id_rsa -N ''")
  echo
  echo "Your public key is"
  cat "${sshDir}/id_rsa.pub"
  echo
else
  echo "Ssh directory found. Skipping ssh generation."
fi
