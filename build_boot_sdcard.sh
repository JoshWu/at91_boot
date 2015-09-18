#!/bin/bash

# Usage: ./build_boot_sdcard.sh <board name>

BOARD_DIRS=$(find . -maxdepth 1 -type d -name "*$1*")
if [ x"$BOARD_DIRS" = x ]; then
	echo "Error: not found folder: $1"
	exit 1
fi
# find two of them, just use the first one
BOARD_DIR=`echo $BOARD_DIRS | cut -d\  -f 1`

echo "Genrate U-Boot environment in folder: ${BOARD_DIR}"
./scripts/gen_ubootenv.sh $1 || exit 1
echo "Done! you can check the env in output/sd/uboot.env"
echo

SD_ENV_DIR=output/sd

# find the mounted SD card.
SDCARD_NAME=SDCARD_BOOT
SDCARD_PATH="/media/${USER}/${SDCARD_NAME}"
if [ ! -d ${SDCARD_PATH} ]; then
	echo "Error: not found sd card in: ${SDCARD_PATH}"
	exit 1
fi

# copy boot files (boot-sd.bin, u-boot-sd.bin, output/sd/uboot.env) to SD card.
while true
do
	read -n 1 -p "Will copy ${BOARD_DIR}/(boot-sd.bin, u-boot-sd.bin) & output/sd/uboot.env to ${SDCARD_PATH} [y/n]:"
	case $REPLY in
		Y|y)
			echo -e "\nCopying boot files and U-Boot .env file to SD card......"
			cp ${BOARD_DIR}/boot-sd.bin ${SDCARD_PATH}/BOOT.BIN
			cp ${BOARD_DIR}/u-boot-sd.bin ${SDCARD_PATH}/u-boot.bin

			[ -f ${BOARD_DIR}/*.dtb ] && cp ${BOARD_DIR}/*.dtb ${SDCARD_PATH}/
			[ -f ${BOARD_DIR}/zImage ] && cp ${BOARD_DIR}/zImage ${SDCARD_PATH}/

			cp ${SD_ENV_DIR}/uboot.env ${SDCARD_PATH}/

			sync
			break;
			;;
		*)
			echo "You cancelled the build process, So nothing changed in SD card!";
			break;
			;;
	esac
done
