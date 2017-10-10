#!/bin/bash

> /var/log/btmp &> /dev/null
echo "Cleared login attempts log (/var/log/btmp)"

currDate=`date +"%Y-%m-%d %T"`
echo "${currDate}: Finished daily cleanup."
exit 0
