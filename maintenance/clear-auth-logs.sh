#!/bin/bash

currDate=`date +"%Y-%m-%d %T"`

> /var/log/btmp &> /dev/null
echo "${currDate}: Cleared login attempts log (/var/log/btmp)"

exit 0
