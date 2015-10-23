# ----------------------------------------------------------------------------
#         ATMEL Microcontroller Software Support 
# ----------------------------------------------------------------------------
# Copyright (c) 2008, Atmel Corporation
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# - Redistributions of source code must retain the above copyright notice,
# this list of conditions and the disclaimer below.
#
# Atmel's name may not be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# DISCLAIMER: THIS SOFTWARE IS PROVIDED BY ATMEL "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT ARE
# DISCLAIMED. IN NO EVENT SHALL ATMEL BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ----------------------------------------------------------------------------

################################################################################
#  Main script: Load the linux demo in DataFlash,
#               Update the environment variables
################################################################################
set bootstrapFile	"boot-spi.bin"
set ubootFile		"u-boot-spi.bin"	
set ubootEnvFile	"../output/spi/uboot.env"

## DataFlash Mapping
set bootStrapAddr	0x000000
set ubootAddr		0x008000
set ubootEnvAddr	0x006000

## serial Flash program
puts "-I- === Init SerialFlash ==="
SERIALFLASH::Init 0

puts "-I- === Erase SerialFlash ==="
SERIALFLASH::EraseAll

puts "-I- === Load the bootstrap image ==="
GENERIC::SendBootFile $bootstrapFile

puts "-I- === Load the u-boot image ==="
send_file {SerialFlash AT25/AT26} "$ubootFile" $ubootAddr 0

puts "-I- === Load the u-boot environment variables ==="
send_file {SerialFlash AT25/AT26} "$ubootEnvFile" $ubootEnvAddr 0

puts "-I- === DONE. ==="
