#!/bin/bash

echo "User: $(whoami) UID: $(id -u) GID: $(id -g)"
gcc --version
# an echo that will stand out in the logs
function announce () {
    echo "##########################################################################################"
    echo "##############################  $*  #################################"
    echo "##########################################################################################"
}

set -e

# export UBOOT_CONFIG="mx6cuboxi_defconfig"
# make mrproper

export PATH="/opt/arm-cortexa9_neon-linux-gnueabihf/bin:$PATH" && \
arm-cortexa9_neon-linux-gnueabihf-gcc --version && \
cd /workspace/u-boot-imx6 && \
export CROSS_COMPILE="arm-cortexa9_neon-linux-gnueabihf-" && \
announce "Building u-boot" && \
make mx6cuboxi_defconfig && \
echo "CONFIG_SPL_BOOT_DEVICE_SDHC=y" >> .config && \
make -j8 && \
announce "image build appears to have been successful" && \
announce "copying files" && \
install -v -m644 -D ./SPL /dist/SPL && \
install -v -m644 -D ./u-boot.img /dist/u-boot.img && \
announce "files copied"



# for file in $(find source -type f -name *.py); do
#     install -m 644 -D ${file} dest/${file#source/}
# done

