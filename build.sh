#!/bin/bash

# The following steps are based on the following information
# - https://hamy.io/post/0015/how-to-compile-openwrt-and-still-use-the-official-repository/
# - https://forum.openwrt.org/t/from-snapshot-to-stable-release-22-03/136038/18?u=rolandomagico

git clone https://github.com/openwrt/openwrt.git -b v24.10.0 openwrt-v24.10.0
cd openwrt-v24.10.0/

git am < ../0001-ipq40xx-Add-support-for-Linksys-MR6350.patch

wget -O .config https://downloads.openwrt.org/releases/24.10.0/targets/ipq40xx/generic/config.buildinfo

make defconfig

# The following command will probably fail, can be ignored. vermagic should be present afterwards anyway
make target/linux/{clean,compile}

# The following command should print the vermagic "60aeaf7e722ca0f86e06f61157755da3"
find build_dir/ -name .vermagic -exec cat {} \;

make download
make -j24
