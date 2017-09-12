#!/bin/bash

# This script creates a new bash script, sets its permissions and more.

# Check if there's a script name given
if [[ ! $1 ]]; then
	echo "Missing script name" > /dev/stderr
	exit 1
fi

# Alternate if
# [[ ! $1 ]] || { echo "Missing script name" >&2; exit 1; }

# If an extension is provided, use that insted of the bash one.
ext=
{ [[ $2 ]] && ext="$2"; } || { ext="sh"; }

# If no path is provided, use default '/shell'
if [[ ! $3 ]]; then
	dir="${PWD}"
else
	dir="${PWD}/{$2}"
fi

# Construct the filename
scriptName="$1"
fileName="${dir}/${scriptName}.${ext}"

# Check if the command name already exists.
# This throws an error if it does not exist, but it'll not be handled right now.
# If 'type' throws an error, then everything is working correctly.
# If it should display something, that means that this script cannot continue.
# Anyway, I want none of the output, thus I redirect it to the 'null' stream.
if type "$scriptName" > /dev/null 2>&1; then
# if sudo type "$scriptName" | /dev/null; then
	echo "There is already a command with name ${scriptName}" > /dev/stderr
	exit 1
fi

# Check if the filename exists
if [[ -e $fileName ]]; then
	echo "File ${fileName} already exists." > /dev/stderr
	exit 1
fi

# If the directory is not there, attempt to create it.
if [[ ! -d $dir ]]; then
	if mkdir "$dir"; then
		echo "Created ${dir}."
	else
		echo "Could not create ${dir}." > /dev/stderr # or 1>&2
		exit 1
	fi
fi

# Create a script with a single line
header=
case $ext in
	js | javascript)
		if type nvm > /dev/null 2>&1; then
			echo "Using latest stable node version."
			nvm use stable > /dev/null 2>&1
		fi
		nodeLoc="$(whereis node)"
		location="$( $(whereis node) )" 2>&1 err
		if [[ ! -e err ]]; then
			echo "Node not found." > /dev/stderr
			exit 1
		fi
		header="#!${location}"
		# header="/root/.nvm/versions/node/v8.2.1/bin/node"
		;;
	*)
		header="#!/bin/bash"
		;;
esac

echo $header > "$fileName"

# Add the execution permission
chmod u+x "$fileName"

# Open the editor
if [[ $EDITOR ]]; then
	$EDITOR "$fileName"
else
	echo "Script created. Unable to open it because \$EDITOR is not set."
fi

exit 0
