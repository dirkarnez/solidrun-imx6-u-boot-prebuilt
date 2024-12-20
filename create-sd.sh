#!/bin/bash

node=
sudo parted -s /dev/${node} mklabel msdos

sudo sfdisk /dev/${node}<<EOF
label: dos
16065,128520,0x0C,*
144585,,,-
EOF

sudo mkfs.fat -F32 -v -n "BOOT" /dev/${node}1
sudo mkfs.ext4 -F -L "rootfs" /dev/${node}2

sudo dd if=SPL of=/dev/${node} bs=1k seek=1 conv=sync
sudo dd if=u-boot.img of=/dev/${node} bs=1k seek=69 conv=sync

# sudo cp hello_world.bin /media/home/BOOT

sync



# sudo sfdisk -s 
# sudo dd if=/dev/zero of=/dev/sdb bs=1M status=progress











# # Tool to flash SD card.
# # Based on tool from Freescale

# set -e



# function help()
# {
# cat <<EOF
# Invoke ". and_patch.sh" from your shell to add following functions to your environment:
# -- c_gotop:	Changes directory to the top of the tree 
# -- c_patch:	Recover working tree to base version and then applying FSL android patch
# EOF
# }



# sfdisk --force -uM -H32 -S32 ${node} << EOF
# ,${boot_rom_sizeb},b
# ,${RECOVERY_ROM_SIZE},83
# ,${extend_size},5
# ,${data_size},83
# ,${SYSTEM_ROM_SIZE},83
# ,${CACHE_SIZE},83
# ,${VENDER_SIZE},83
# ,${MISC_SIZE},83
# EOF


# dd if=/dev/zero of=${node} bs=1024 count=1
