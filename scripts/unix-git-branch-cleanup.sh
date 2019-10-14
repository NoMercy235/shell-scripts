#!/bin/bash

path=$1
echo "Branch that no longer exist locally on \"${path}\":"
echo ""

cd $path

# branches=$(git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }')
# echo "$branches"
# echo ""

echo "Untracked the following branches from origin:"
git prune remote origin

# On MacOS remove the "-r" argument from the xargs command.
echo "Deleted the following branches:"
git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -d
