#!/bin/sh

sam-ba /dev/ttyACM0 at91sam9x35-ek ../scripts/samba/write_serialflash.tcl 2>&1 | tee logfile.log
