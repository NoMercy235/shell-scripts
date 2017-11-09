#!/bin/bash

currDate=`date +"%Y-%m-%d %T"`
echo "${currDate}: Daily docker cleanup."

danglingImg=$(docker images -f dangling=true -q)
if [[ ! -z $danglingImg ]]; then
    docker rmi $danglingImg
fi

danglingVols=$(docker volume ls -f dangling=true -q)
if [[ ! -z $danglingVols ]]; then
    docker volume rm $danglingVols
fi

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc:ro spotify/docker-gc
echo "Cleaned up docker's garbage."

echo "${currDate}: Finished daily docker cleanup."
exit 0
