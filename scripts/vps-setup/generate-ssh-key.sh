sshDir="${HOME}/.ssh/"
if [ ! -d "$sshDir" ]; then
  ssh-keygen
else
  echo "Ssh directory found. Skipping ssh generation."
fi
