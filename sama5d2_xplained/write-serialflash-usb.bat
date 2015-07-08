rem Flash a Linux-based demo 
@echo "===== Flashing demo to board ====="
call sambacmd.bat -x write-serialflash-usb.qml
call sambacmd.bat -x write-boot_sequence-usb.qml
@echo "===== Script done. ====="
pause
