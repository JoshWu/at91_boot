#!/bin/bash

# Usage: ./gen_ubootenv.sh <board name>

# $1: board folder, which includes boot.bin, u-boot.bin
# create a env_tmp.txt for build, which will override the board
# specified U-Boot variables.
function combine_uboot_env() {
	local _BOARD_PATH=$1

	cp env.txt env_tmp.txt
	if [ ! -f ${_BOARD_PATH}/env.txt ]; then
		# just use save env.txt
		return 0;
	fi;

	# find variables in board path.
	local _VAR_NAMES=$(awk -F= '{print $1}' ${_BOARD_PATH}/env.txt)
	if [ "x${_VAR_NAMES}" = "x" ]; then
		echo "Error: not found the variable in: ${_BOARD_PATH}/env.txt"
		return 1
	fi

	# delete the overrided variables on env_tmp.txt
	for _VAR_NAME in ${_VAR_NAMES}
	do
		sed -i "/^${_VAR_NAME}=/ d" env_tmp.txt
	done

	# combine the board's env.txt to the end of env_tmp.txt
	cat ${_BOARD_PATH}/env.txt >> env_tmp.txt

	return 0
}

function generate_random_eth_addr() {
	local _VAR_UBOOT_ETH="ethaddr="
	local _VAR_UBOOT_ETH1="eth1addr="

	local _VAR_ADDR=`./scripts/gen_ethaddr.sh`
	local _VAR_ADDR1=`./scripts/gen_ethaddr.sh`

	echo "${_VAR_UBOOT_ETH}${_VAR_ADDR}" >> env.txt
	echo "${_VAR_UBOOT_ETH1}${_VAR_ADDR1}" >> env.txt
}

function prepare_uboot_env() {
	local _BOARD_PATH=$1

	# combine env_demo_auto_flash.txt to env.txt
	cat env_config.txt env_common.txt env_demo_auto_flash.txt > env.txt

	cat ${_BOARD_PATH}/env_common.txt ${_BOARD_PATH}/env_demo_auto_flash.txt > ${_BOARD_PATH}/env.txt
}

# check parameters
if [ $# != 1 ]; then
	echo "Error: should specify a board name as a parameter!"
	exit 1
fi

# choose the which board to boot
BOARD_DIR=$(find . -maxdepth 1 -type d -name "*$1*")
if [ "x${BOARD_DIR}" = "x" ]; then
	echo "Error: not found the board folder for: $1"
	exit 1
fi

# TODO: if we find more than one board folder?

# generate env.txt
prepare_uboot_env ${BOARD_DIR}

# generate 2 eth addresses append to env.txt
generate_random_eth_addr

# combine the env.txt file for spcified board
combine_uboot_env ${BOARD_DIR}
if [ $? -ne 0 ]; then
	echo "Error: cannot combile the board env.txt!"
	exit 1
fi

# generate a uboot.env from env_tmp.txt.
# -s CONFIG_ENV_SIZE

mkdir -p output/sd
mkdir -p output/spi

# sd card env file
./mkenvimage -s 0x4000 -o output/sd/uboot.env env_tmp.txt

# spi env binary
./mkenvimage -s 0x2000 -p 0x0 -o output/spi/uboot.env env_tmp.txt

