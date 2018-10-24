#!/bin/sh

currDate=`date +"%Y-%m-%d %T"`
echo "${currDate}: Disk usage report."

du -skh /home/
du -skh /usr/
du -skh /var/

echo "${currDate}: End of disk usage report."

exit 0

