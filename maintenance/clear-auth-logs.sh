#!/bin/bash

> /var/log/btmp &> /dev/null
echo "Cleared login attempts log (/var/log/btmp)"

exit 0
