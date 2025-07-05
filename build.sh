#!/bin/bash
# Configuration section
OPENWRT_TAG=v24.10.2
DEVICE_PATCH=0001-mediatek-filogic-D-Link-M30-M60-include-initramfs-in.patch
CONFIG_BUILDINFO=https://mirror-03.infra.openwrt.org/releases/24.10.2/targets/mediatek/filogic/config.buildinfo
ARTIFACTS=*M30*

# Create directory for storing the build result
mkdir output

# The following steps are based on the following information
# - https://hamy.io/post/0015/how-to-compile-openwrt-and-still-use-the-official-repository/
# - https://forum.openwrt.org/t/from-snapshot-to-stable-release-22-03/136038/18?u=rolandomagico

git clone https://github.com/openwrt/openwrt.git -b $OPENWRT_TAG
cd openwrt/

git am < ../$DEVICE_PATCH
git am < ../0002-mediatek-filogic-D-Link-M30-add-OpenWrt-partition-la.patch

./scripts/feeds update -a && ./scripts/feeds install -a

wget -O .config $CONFIG_BUILDINFO

make defconfig

# The following command will probably fail, can be ignored. vermagic should be present afterwards anyway
make target/linux/{clean,compile}

# The following command should print the vermagic "6a9e125268c43e0bae8cecb014c8ab03"
find build_dir/ -name .vermagic -exec cat {} \;
read -p "Press enter to continue"

make download
make -j

cp bin/*/*/$ARTIFACTS ../output
