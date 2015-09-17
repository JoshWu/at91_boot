#!/bin/bash

# Usage: ./build_boot_spi.sh <board name>

./scripts/gen_ubootenv.sh $1 || exit 1

BOARD_DIR=$(find . -maxdepth 1 -type d -name "*$1*")

SPI_ENV_DIR=output/spi

# copy boot files to output folder
cp ${BOARD_DIR}/boot-spi.bin ${SPI_ENV_DIR}/
cp ${BOARD_DIR}/u-boot-spi.bin ${SPI_ENV_DIR}/

echo "Done: Finished copying to" ${SPI_ENV_DIR}

while true
do
	read -n 1 -p "Will run sam-ba to flash the binaries(boot-spi.bin, u-boot-spi.bin, uboot.env) to board[y/n]:"
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
			echo "You cancelled the flash process, So nothing flashed into board!";
			break;
			;;
	esac
done
