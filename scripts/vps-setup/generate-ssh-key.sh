sshDir="${HOME}/.ssh"
if [ ! -d "$sshDir" ]; then
  echo "Setting up SSH"
  ssh-keygen -f "${sshDir}/id_rsa" -N ""
  echo
  echo "Your public key is"
  cat "${sshDir}/id_rsa.pub"
  echo
else
  echo "Ssh directory found. Skipping ssh generation."
fi
