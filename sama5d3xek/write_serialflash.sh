#!/bin/sh

sam-ba /dev/ttyACM0 at91sama5d3x-ek ../scripts/samba/write_serialflash.tcl 2>&1 | tee logfile.log
