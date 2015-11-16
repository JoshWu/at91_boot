#!/bin/bash

# Usage: ./build_boot_spi.sh <board name>

BOARD_DIRS=$(find . -maxdepth 1 -type d -name "*$1*")
if [ x"$BOARD_DIRS" = x ]; then
	echo "Error: not found folder: $1"
	exit 1
fi
# find two of them, just use the first one
BOARD_DIR=`echo $BOARD_DIRS | cut -d\  -f 1`

echo "Genrate U-Boot environment in folder: ${BOARD_DIR}"
./scripts/gen_ubootenv.sh $1 || exit 1
echo "Done! you can check the env in output/spi/uboot.env"
echo

SPI_ENV_DIR=output/spi

# copy boot files to output folder
cp ${BOARD_DIR}/boot-spi.bin ${SPI_ENV_DIR}/
cp ${BOARD_DIR}/u-boot-spi.bin ${SPI_ENV_DIR}/

echo "Done: Finished copying binaries to" ${SPI_ENV_DIR}
echo

echo "Will run sam-ba to flash the binaries(boot-spi.bin, u-boot-spi.bin, uboot.env) to board"
echo "You need to:"

SPI_DETECT_README=spi_detect.txt
if [ -f ${BOARD_DIR}/${SPI_DETECT_README} ]; then
	cat ${BOARD_DIR}/${SPI_DETECT_README}
else
	echo "1. Connect usb cable to the board."
	echo "2. CLOSE the BMS or BOOT_DIS jump pins or press the DIS_BOOT/CS_BOOT button"
	echo "3. Power on or reset the board"
	echo "4. Make sure the SPI jump pin is closed"
	echo "5. OPEN the BMS or BOOT_DIS jump pins and release DIS_BOOT/CS_BOOT button to enable spiflash."
fi
echo

while true
do
	read -n 1 -p "Do you finish above steps? [y/n]:"
	case $REPLY in
		Y|y)
			_SAMBA_SCRIPT=$(find ${BOARD_DIR} -maxdepth 1 -type f -name "*.sh")
			if [ "x${_SAMBA_SCRIPT}" != "x" ]; then
				echo -e "\nRunning script to connect board......"

				# run the samba .sh script
				cd ${BOARD_DIR}
				./`basename ${_SAMBA_SCRIPT}`
				cd -
			else
				echo -e "\nERROR: Samba .sh script not found!"
			fi

			break;
			;;
		*)
			echo
			echo "You cancelled the flash process, So nothing flashed into board!";
			break;
			;;
	esac
done
