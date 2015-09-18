#!/bin/sh

sam-ba /dev/ttyACM0 at91sam9m10-ekes ../scripts/samba/write_dataflash_at45.tcl 2>&1 | tee logfile.log
