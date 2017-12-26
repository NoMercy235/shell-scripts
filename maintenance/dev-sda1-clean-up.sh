#!/bin/sh

currDate=`date +"%Y-%m-%d %T"`
echo "${currDate}: Cleanup for dev/sda1."

# For Ubuntu < 16.04
# dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p' | xargs sudo apt-get -y purge

# For Ubuntu >= 16.04
apt-get autoremove

currDate=`date +"%Y-%m-%d %T"`
echo "${currDate}: End of cleanup."

exit 0
