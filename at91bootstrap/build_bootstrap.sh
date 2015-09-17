#!/bin/bash

#################################
# Desription:
#	This script will build all at91bootstrap binaries for all configs
#	  tag name is optional.
#
# usage:
#	./build_bootstrap.sh <tag name>
#
#	if not tag name then just build current at91bootstrap source.
#################################

DESCRIPTION_STRING='	This script will build all at91bootstrap binaries for all configs
	'

USAGE_STRING='	./build_bootstrap.sh <tag name>'

function display_usage()
{
	echo "Description:"
	echo -e "$DESCRIPTION_STRING"
	echo "Usage:"
	echo -e "$USAGE_STRING"
	echo
}

if [ $# -gt 1 ]; then
	# parameters number is larger than 1 , then error
	display_usage
	exit 1
fi

TOPDIR=`pwd`
export CROSS_COMPILE=arm-linux-gnueabi-
AT91BOOTSTRAP_FOLDER=${HOME}/work/at91bootstrap/at91
AT91BOOTSTRAP_VER=`(cd ${AT91BOOTSTRAP_FOLDER} && git describe)`
OUTPUT=${TOPDIR}/${AT91BOOTSTRAP_VER}

if [ -d $OUTPUT ]; then
    rm -rf $OUTPUT
fi
mkdir $OUTPUT

# go into at91bootstrap root folder
pushd ${AT91BOOTSTRAP_FOLDER}

# TODO: Check the tag and swith to the tag

# clean up
make mrproper

CONFIG_LIST=`find ./board -name *_defconfig | awk '{print "basename", $NF}' | sh`
for CONFIG in $CONFIG_LIST
do
    echo Build for $CONFIG
    make clean
    make $CONFIG
    make
    if [ $? -ne 0 ]; then echo "Fail to build $CONFIG"; popd; exit 1; fi

    cp binaries/at91bootstrap.bin $OUTPUT/${CONFIG}.bin
done

popd

# TODO: rename the output folder to tag name
