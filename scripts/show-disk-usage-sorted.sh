#!/bin/bash

path=$1
head=$2

du -a $path | sort -n -r | head -n $head
