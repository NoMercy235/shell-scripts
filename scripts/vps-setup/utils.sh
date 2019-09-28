#!/bin/bash

NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

function echoTitle {
    message=$1
    echo
    echo -e "${CYAN}======================================================="
    echo -e "${message}"
    echo -e "=======================================================${NONE}"
    echo
}

function runForUser {
    user=$1
    command=$2
    echo "su -c \"$command\" $user"
}