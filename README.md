solidrun-imx6-uboot-prebuilt
============================
- [i.MX6 U-Boot - Developer Center -  SolidRun](https://solidrun.atlassian.net/wiki/spaces/developer/pages/287179374/i.MX6+U-Boot#Compiling-from-source)
    - `git clone --branch v2018.01-solidrun-imx6 https://github.com/SolidRun/u-boot.git /workspace/u-boot-imx6`
    - > Note: The resulting binaries are `SPL` and `u-boot.img`.
- [arm-linux-gnueabihf、aarch64-linux-gnu等ARM交叉编译GCC的区别_aarch64-elf-gcc aarch64-linux-gnu-CSDN博客](https://blog.csdn.net/Namcodream521/article/details/88379307)
- [u-boot/board/solidrun/mx6cuboxi/README at v2018.01-solidrun-imx6 · SolidRun/u-boot](https://github.com/SolidRun/u-boot/blob/v2018.01-solidrun-imx6/board/solidrun/mx6cuboxi/README)
### Notes
- Compiling u-boot requires Linux and **non-baremetal** gcc compiler
- SPL = secondary program loader
    - [u-boot spl 学习总结 - 小麦大叔 - 博客园](https://www.cnblogs.com/unclemac/p/12783383.html)
- Compilation requires some .so files (I guess QEMU is compiled and invoked behind-the-scene) that i have to make symlink for them which installed by `gcc-aarch64-linux-gnu` and `g++-aarch64-linux-gnu` packages
    - https://github.com/conan-io/conan/issues/16070
    - [qemu /lib/ld-linux-aarch64.so.1: No such file or directory_linux编译 ld-linux-aarch64.so.1:no such-CSDN博客](https://blog.csdn.net/FJDJFKDJFKDJFKD/article/details/112828882)
- `SPL` issue is caused by name clash (`make SPL` cannot work with existing folder named "spl" in Windows filesystem volumed):
    - ```sh
      OBJCOPY spl/u-boot-spl-nodtb.bin
      COPY    spl/u-boot-spl.bin
      CFGS    arch/arm/mach-imx/spl_sd.cfg.cfgtmp
      MKIMAGE SPL
      ./tools/mkimage: Can't open SPL: Is a directory
      make[1]: *** [arch/arm/mach-imx/Makefile:96: SPL] Error 1
      make: *** [Makefile:1072: SPL] Error 2
      ```
    - ~Solution: I have changed `make SPL` target to `make _SPL`~
    - **DO NOT volume [`u-boot-imx6`](./u-boot-imx6) directly**

### How about firmwares
- Firmwares are usually closed-source because it is written and provided by chip (e.g. WIFI chip) vendors
    - [SolidRun/deb-pkg_cuboxi-firmware-wireless: Vendor firmware required for the wireless chips on the SolidRun i.MX6 based SOMs](https://github.com/SolidRun/deb-pkg_cuboxi-firmware-wireless)
        - This repo SolidRun package firmware from vendor Broadcom  
    - You can usually access the hardware registers and peripherals directly, even if the firmware is closed-source.
    - firmware makes things easier, in baremetal programming we may still access hardware directly (firmware is like helper library)
  
### How to use the prebuilt binary
1. Better get a linux (for `dd` utility), or try [dd for windows](http://www.chrysocome.net/dd)
2. use `dd` to copy the binary content of `SPL` and `u-boot.img` to microSD card
    - ```bash
      dd if=SPL of=/dev/sdX bs=1k seek=1 conv=sync
      dd if=u-boot.img of=/dev/sdX bs=1k seek=69 conv=sync
      ```
    - > The Boot-ROM searches for the SPL after the first 1024 bytes. The SPL then looks for the full u-boot binary at both 69k and 42k. The dd command can be used for writing SPL and u-boot to these locations on your microSD card. Substitute sdX by the device node of your sdcard.
    - [i.MX6 U-Boot - Developer Center -  SolidRun](https://solidrun.atlassian.net/wiki/spaces/developer/pages/287179374/i.MX6+U-Boot#Download-Binaries)
3. Boot the microSD card
4. OS loads the SPL and then U-Boot, after that U-Boot will search for all attached storage for bootable files such as boot scripts, extlinux configuration or EFI applications.
    1. References
        - [bootz 启动 kernel_image->ep-CSDN博客](https://blog.csdn.net/lyndon_li/article/details/126150965)
        - [uboot启动内核命令：bootz、bootm、boot_uboot bootm-CSDN博客](https://blog.csdn.net/Calmer_/article/details/131070786)
        - Boot script is a DSL from U-Boot, written in a separate file (for more flexibility) or embedded in U-Boot code
    2. load the DeviceTree Binary (e.g. bcm2711-rpi-4-b.dtb)
    3. load the kernel image (e.g. start4.elf)
    4. load the initramfs (**Linux only**, optional) or your own baremetal application loaded by kernel image
    5. set boot commandline options
    6. execute

### For baremetal application
1. Set Up U-Boot: Configure U-Boot to load your binary (often in ELF or binary format).
2. Write Startup Code: Initialize the stack, set up the hardware, and jump to your main function.
3. Direct Hardware Access: Use memory-mapped I/O to interact with peripherals.
4. Compile and Link: Use a cross-compiler to build your program for the target architecture.
5. Upload and Test: Load the binary using U-Boot commands and test functionality.
    
### Tutorials
- [Compiling latest U-Boot for i.MX6 (2015 edition) | Laird Connectivity is Now Ezurio](https://www.ezurio.com/resources/software-announcements/compiling-latest-u-boot-for-i-mx6-2015-edition)

### Compilers
- [Downloads | GNU-A Downloads – Arm Developer](https://developer.arm.com/downloads/-/gnu-a)

### Linux Kernel
- [i.MX6 Kernel - Developer Center -  SolidRun](https://solidrun.atlassian.net/wiki/spaces/developer/pages/286916713)

### PCB
- [HummingBoard Pro Quick Start Guide - Developer Center -  SolidRun](https://solidrun.atlassian.net/wiki/spaces/developer/pages/270631039/HummingBoard+Pro+Quick+Start+Guide#Hardware-Setup)

### Reference
- [Embedded PowerPC Linux Boot Code download | SourceForge.net](https://sourceforge.net/projects/ppcboot/)
- [Yocto for i.MX6 - Developer Center -  SolidRun](https://solidrun.atlassian.net/wiki/spaces/developer/pages/287277558/Yocto+for+i.MX6)
- [HummingBoard Pro Quick Start Guide - Developer Center -  SolidRun](https://solidrun.atlassian.net/wiki/spaces/developer/pages/270631039/HummingBoard+Pro+Quick+Start+Guide#Hardware-Setup)
- [Cross build environment - Gentoo wiki](https://wiki.gentoo.org/wiki/Cross_build_environment#Allwinner_A20_specific)
- [Knowledge/articles/Quick_Review_of_NanoPi_NEO4.md at master · ThomasKaiser/Knowledge](https://github.com/ThomasKaiser/Knowledge/blob/master/articles/Quick_Review_of_NanoPi_NEO4.md)
- [Knowledge/articles/Quick_Preview_of_ROCK_5_ITX.md at master · ThomasKaiser/Knowledge](https://github.com/ThomasKaiser/Knowledge/blob/master/articles/Quick_Preview_of_ROCK_5_ITX.md)
- [**Blobless boot with RockPro64 | Andrius Štikonas**](https://stikonas.eu/wordpress/2019/09/15/blobless-boot-with-rockpro64/)
