#!/bin/bash

currDate=`date +"%Y-%m-%d %T"`
echo "${currDate}: Daily cleanup."

danglingImg=$(docker images -f dangling=true -q)
if [[ ! -z $danglingImg ]]; then
    docker rmi $danglingImg
fi

danglingVols=$(docker volume ls -f dangling=true -q)
if [[ ! -z $danglingVols ]]; then
    docker volume rm $danglingVols
fi

echo "${currDate}: Finished daily cleanup."
exit 0
