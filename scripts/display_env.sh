#!/bin/bash

# convert line from
#	ethaddr=01234
# to:
#	setenv ethaddr '01234'
#
# Usage:
#	./scripts/display_env.sh env_common.txt

if [ ! -f $1 ]; then
	echo "Error: not found the file : $1"
	exit 1;
fi

# \047 is octal number, it is just: ' 
awk -F= '{out=""; for(i=2;i<NF;i++){out=out""$i"="}; out=out""$NF; print "setenv", $1, "\047" out "\047"}' $1
