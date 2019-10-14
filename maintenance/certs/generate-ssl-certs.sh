#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

command="certbot certonly --standalone"

# Loop through all args
domains=""
while [ "$1" != "" ]; do
    domain=$1
    command="${command} -d ${domain}"
    domains="${domains} ${domain}"

    # Shift all the parameters down by one
    shift
done

echo "Generating certs for the following domains: ${domains}"

eval $command

exit 0

