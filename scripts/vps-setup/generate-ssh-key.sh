sshDir="${HOME}/.ssh/"
if [ ! -d "$sshDir" ]; then
  echo "Setting up SSH"
  ssh-keygen -f "${sshDir}/id_rsa" -N ""
else
  echo "Ssh directory found. Skipping ssh generation."
fi
