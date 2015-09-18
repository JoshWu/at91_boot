#!/bin/sh

sam-ba /dev/ttyACM0 at91sam9n12-ek ../scripts/samba/write_serialflash.tcl 2>&1 | tee logfile.log
