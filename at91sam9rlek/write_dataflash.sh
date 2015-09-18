#!/bin/sh

sam-ba /dev/ttyACM0 at91sam9rl64-ek ../scripts/samba/write_dataflash_at45.tcl 2>&1 | tee logfile.log
