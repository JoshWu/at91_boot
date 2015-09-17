#!/bin/bash

#################################
# Desription:
#	Link the binaries folder to the one you specified
#
# usage:
#	./relink.sh <folder name>
#################################

DESCRIPTION_STRING='	Link the binaries folder to the specified folder
	'

USAGE_STRING='	./relink.sh <folder>'

function display_usage()
{
	echo "Description:"
	echo -e "$DESCRIPTION_STRING"
	echo "Usage:"
	echo -e "$USAGE_STRING"
	echo
}

# Check parameters
if [ $# -ne 1 ]; then
	# parameters number is not 1, then error
	display_usage
	exit 1
fi

# Check the user specified folder is exist
if [ ! -d $1 ]; then
	echo "$1 is not existed folder!"
	exit 1
fi

[ -L binaries ] && rm binaries
ln -sv $1 binaries
