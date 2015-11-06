# Description
The project is to make use easy to build a bootable SD card for all at91 board.
Also it can flash the bootable code to spi flash for all at91 boards as well.

In the meantime, it will also has specified U-Boot variables for each board.
You can configure them by yourself and customized for each board.

# Usage
## Make a bootable SD card
1. Prepare a SD card, FAT format, and the volume name should be: `SDCARD_BOOT`
2. Insert the SD card to PC.
3. Run `./build_boot_sdcard.sh <boardname>`
   for example sama5d4ek:
   ```./build_boot_sdcard.sh sama5d4ek```
4. That's it. The SD card should be bootable.

## Flash bootable binaries to spi flash of the board
1. You need install SAM-BA first.
2. Connect board to PC via USB cable.
3. Press DIS_BOOT or disable boot media and power up the board. So that board
   will be sam-ba monitor mode.
4. Run `./build_boot_spi.sh <boardname>`
   for example sama5d4ek:
   ```./build_boot_spi.sh sama5d4ek```
5. Now board can boot up well.

# Configuration the U-Boot variables
## U-Boot environment configurate
1. env_common.txt is a common u-boot environment variables. It's for all boards.
2. <board name>/env_common.txt is board relevant, it will override same
   variables in the top dir's env_common.txt.
3. env_nand.txt is some variables & command related with nand operation.
   It can flash the SD card binary files into nand flash.

# Update the at91bootstrap & u-boot binaries:
1. cd at91bootstrap source folder
2. run build_bootstrap.sh to build all at91bootstrap binaries.
3. link the output folder to binaries:
   ```./relink <Commit ID>```
4. cd u-boot source folder
5. run build_uboot.sh to build all u-boot binaries.
6. link the output folder folder to binaries:
   ```./relink <Commit ID>```

# Issues:
1. My SD card cannot boot and nothing or RomBOOT displayed?

As before sama5d3xek, the ROMCode have some bugs so sometime it cannot found the boot.bin in FAT partition. To solve this, you can do:
  a. Insert your card to Win7 machine, and format the whole card. (without partition table)
  b. Copy a boot.bin file to SD card.
  c. Remove it from Win7 machine, then insert the SD card to Linux machine, and run this script again.
  d. Remove the card and insert to the board to boot.

# Tested SD card boot support:
## Kingston 32G class 4 SD card
```
U-Boot>mmcinfo

Device: mci
Manufacturer ID: 2
OEM: 544d
Name: SD32G
Tran Speed: 50000000
Rd Block Len: 512
SD version 2.0
High Capacity: Yes
Capacity: 30.4 GiB
Bus Width: 4-bit
```

| Boards        | tested and supported   |
| --------   | -----  |
| at91sam9m10g45ek  |  OK   |
| sama5d3xek    | OK |
| sama5d4ek    | N/A, only support microSD |
| sama5d2_xplained    |  |
| sama5d3_xplained    |  |
| sama5d4_xplained    |  |


## SanDisk 2G MicroSD card
```
U-Boot> mmcinfo

Device: mci
Manufacturer ID: 1b
OEM: 534d
Name: 00000
Tran Speed: 50000000
Rd Block Len: 512
SD version 3.0
High Capacity: No
Capacity: 1.9 GiB
Bus Width: 4-bit
```

| Boards        | tested and supported   |
| --------   | -----  |
| at91sam9m10g45ek  |  N/A, only support SD card   |
| sama5d3xek    | N/A |
| sama5d4ek    | OK |
| sama5d2_xplained    |  |
| sama5d3_xplained    |  |
| sama5d4_xplained    |  |
