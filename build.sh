#!/bin/bash

# The following steps are based on the following information
# - https://hamy.io/post/0015/how-to-compile-openwrt-and-still-use-the-official-repository/
# - https://forum.openwrt.org/t/from-snapshot-to-stable-release-22-03/136038/18?u=rolandomagico

git clone https://github.com/openwrt/openwrt.git -b v23.05.5 openwrt-v23.05.05
cd openwrt-v23.05.05/

git am < ../0001-ipq40xx-Add-support-for-Linksys-MR6350.patch

./scripts/feeds update -a && ./scripts/feeds install -a

wget -O .config https://downloads.openwrt.org/releases/23.05.5/targets/ipq40xx/generic/config.buildinfo

make defconfig

# The following command will probably fail, can be ignored. vermagic should be present afterwards anyway
make target/linux/{clean,compile}

# The following command should print the vermagic "8f9ae65a21e1c33e542689b57c4d70f0"
find build_dir/ -name .vermagic -exec cat {} \;
read -p "Press enter to continue"

make download
make -j24
