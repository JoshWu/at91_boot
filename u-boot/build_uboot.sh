#!/bin/sh

# combine board with media type as the full defconfig files.
AT91_BOARD="sama5d3xek sama5d4ek sama5d3_xplained sama5d4_xplained sama5d2_xplained at91sam9x5ek at91sam9n12ek at91sam9m10g45ek at91sam9rlek at91sam9g20ek"
#AT91_BOARD="sama5d3xek sama5d3_xplained sama5d3xek_cmp"
UBOOT_MEDIA="mmc nandflash spiflash"

TOPDIR=`pwd`
export CROSS_COMPILE=arm-linux-gnueabi-
UBOOT_FOLDER=${HOME}/work/u-boot/at91
UBOOT_VER=`(cd ${UBOOT_FOLDER} && git describe)`
OUTPUT=${TOPDIR}/${UBOOT_VER}
if [ -d $OUTPUT ]; then
    rm -rf $OUTPUT
fi
mkdir $OUTPUT

pushd ${UBOOT_FOLDER}

for BOARD_TYPE in $AT91_BOARD
do
	for CUR_MEDIA in $UBOOT_MEDIA
	do
		UBOOT_DEFCONFIG="${BOARD_TYPE}_${CUR_MEDIA}_defconfig"

		# check whether this config is exist, if no, just do next
		[ -f configs/${UBOOT_DEFCONFIG} ] || continue

		echo ""
		echo "Build ${UBOOT_DEFCONFIG}..."

		make mrproper > /dev/null
		make ${UBOOT_DEFCONFIG}
	       	if [ $? -ne 0 ]; then
			echo; echo "Error: make ${UBOOT_DEFCONFIG}"; exit 1
		fi

		make -j8
		if [ $? -ne 0 ]; then
			echo; echo "Error: when build ${UBOOT_DEFCONFIG}"; exit 1
		fi

		cp u-boot.bin ${OUTPUT}/${UBOOT_DEFCONFIG}_u-boot.bin
		[ -f spl/u-boot-spl.bin ] && cp spl/u-boot-spl.bin ${OUTPUT}/${UBOOT_DEFCONFIG}_u-boot-spl.bin
		echo
	done
done

popd
