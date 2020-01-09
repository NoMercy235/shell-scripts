projectsDir="${HOME}/Documents/projects"
if [ -d "$projectsDir" ]; then
  mkdir -p "$projectsDir"
fi

echo "Please make sure that the ssh public key has been added to the GitHub settings page before continuing"
echo "Press any key to continue"
read _

git clone git@github.com:NoMercy235/shell-scripts.git

mkdir -p "${projectsDir}/cyoa"
git clone git@github.com:NoMercy235/cyoa-frontend.git cyoa/cyoa-frontend
git clone git@github.com:NoMercy235/cyoa-backend.git cyoa/cyoa-backend

source ~/.bashrc
npm -v
