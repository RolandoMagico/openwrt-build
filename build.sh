#!/bin/bash
# Configuration section
OPENWRT_TAG=v24.10.0
DEVICE_PATCH=0001-ramips-Add-support-for-Cudy-M1300-v2.patch
CONFIG_BUILDINFO=https://mirror-03.infra.openwrt.org/releases/24.10.0/targets/ramips/mt7621//config.buildinfo

# The following steps are based on the following information
# - https://hamy.io/post/0015/how-to-compile-openwrt-and-still-use-the-official-repository/
# - https://forum.openwrt.org/t/from-snapshot-to-stable-release-22-03/136038/18?u=rolandomagico

git clone https://github.com/openwrt/openwrt.git -b $OPENWRT_TAG
cd openwrt/

git am < ../$DEVICE_PATCH

./scripts/feeds update -a && ./scripts/feeds install -a

wget -O .config $CONFIG_BUILDINFO

make defconfig

# The following command will probably fail, can be ignored. vermagic should be present afterwards anyway
make target/linux/{clean,compile}

# The following command should print the vermagic "3abe85def815b59c6c75ac1f92135cb6"
find build_dir/ -name .vermagic -exec cat {} \;
read -p "Press enter to continue"

make download
make -j
