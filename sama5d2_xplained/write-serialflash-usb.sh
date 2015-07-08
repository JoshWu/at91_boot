#!/bin/sh
# Flash a Linux-based demo 

echo "===== Flashing demo to board ====="
sambacmd -x write-serialflash-usb.qml
sambacmd -x write-boot_sequence-usb.qml
echo "===== Script done. ====="
exit 0
