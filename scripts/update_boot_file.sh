#!/bin/bash

#################################
# Desription:
#	Update the binaries for all supported boards
#
# usage:
#	./update_boot_file.sh
#################################

DESCRIPTION_STRING='	Update the binaries for all supported boards
	'

USAGE_STRING='	./update_boot_file.sh'

function display_usage()
{
	echo "Description:"
	echo -e "$DESCRIPTION_STRING"
	echo "Usage:"
	echo -e "$USAGE_STRING"
	echo
}

# Check parameters
if [ $# -ne 0 ]; then
	# parameters number is not 1, then error
	display_usage
	exit 1
fi

# combine board with media type as the full defconfig files.
AT91_BOARD="sama5d3xek sama5d4ek sama5d3_xplained sama5d4_xplained sama5d2_xplained at91sam9x5ek at91sam9n12ek at91sam9m10g45ek at91sam9rlek"
UBOOT_MEDIA="mmc nandflash spiflash"

TOPDIR=`pwd`
UBOOT_PATH=${TOPDIR}/u-boot/binaries
BOOT_PATH=${TOPDIR}/at91bootstrap/binaries

for BOARD_TYPE in $AT91_BOARD
do
	for CUR_MEDIA in $UBOOT_MEDIA
	do
		# board folder
		BOARD_DIR=${BOARD_TYPE}
		if [ ! -d $BOARD_DIR ]; then
			echo "WARNING: $BOARD_DIR is not existed, so create it!"
			mkdir $BOARD_DIR
		fi

		UBOOT_DEFCONFIG="${BOARD_TYPE}_${CUR_MEDIA}_defconfig"
		UBOOT_BIN=${UBOOT_DEFCONFIG}_u-boot.bin
		if [ ! -f ${UBOOT_PATH}/${UBOOT_BIN} ]; then
			echo "WARNING: file: ${UBOOT_PATH}/${UBOOT_BIN} not found!"
		fi

		BOOT_MEDIA_PREFIX=""
		[ x"$CUR_MEDIA" = x"mmc" ] && BOOT_MEDIA_PREFIX="sd"
		[ x"$CUR_MEDIA" = x"nandflash" ] && BOOT_MEDIA_PREFIX="nf"
		[ x"$CUR_MEDIA" = x"spiflash" ] && BOOT_MEDIA_PREFIX="df"
		if [ x"$BOOT_MEDIA_PREFIX" = x ]; then
			echo "ERROR: not recognized media prefix: ${CUR_MEDIA}"
			exit 1
		fi

		BOOT_DEFCONFIG="${BOARD_TYPE}${BOOT_MEDIA_PREFIX}_uboot_defconfig"
		[ x"$BOARD_TYPE" = x"sama5d4ek" ] && BOOT_DEFCONFIG="${BOARD_TYPE}${BOOT_MEDIA_PREFIX}_uboot_secure_defconfig"
		[ x"$BOARD_TYPE" = x"sama5d4_xplained" ] && BOOT_DEFCONFIG="${BOARD_TYPE}${BOOT_MEDIA_PREFIX}_uboot_secure_defconfig"
		BOOT_BIN=${BOOT_DEFCONFIG}.bin
		if [ ! -f ${BOOT_PATH}/${BOOT_BIN} ]; then
			echo "WARNING: file: ${BOOT_PATH}/${BOOT_BIN} not found!"
		fi

		pushd $BOARD_DIR

		FILE_PREFIX=""
		[ x"$CUR_MEDIA" = x"mmc" ] && FILE_PREFIX="sd"
		[ x"$CUR_MEDIA" = x"nandflash" ] && FILE_PREFIX="nand"
		[ x"$CUR_MEDIA" = x"spiflash" ] && FILE_PREFIX="spi"

		rm boot-${FILE_PREFIX}.bin
		[ -f ../at91bootstrap/binaries/$BOOT_BIN ] && ln -sv ../at91bootstrap/binaries/$BOOT_BIN boot-${FILE_PREFIX}.bin

		rm u-boot-${FILE_PREFIX}.bin
		[ -f ../u-boot/binaries/$UBOOT_BIN ] && ln -sv ../u-boot/binaries/$UBOOT_BIN u-boot-${FILE_PREFIX}.bin

		popd
	done
done
