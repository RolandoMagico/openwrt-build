#!/bin/bash
# Configuration section
OPENWRT_TAG=v24.10.1
DEVICE_PATCH=0001-mediatek-filogic-Add-support-for-cudy-wr3000h.patch
CONFIG_BUILDINFO=https://mirror-03.infra.openwrt.org/releases/24.10.1/targets/mediatek/filogic/config.buildinfo
ARTIFACTS=*WR3000H*

# Create directory for storing the build result
mkdir output

# The following steps are based on the following information
# - https://hamy.io/post/0015/how-to-compile-openwrt-and-still-use-the-official-repository/
# - https://forum.openwrt.org/t/from-snapshot-to-stable-release-22-03/136038/18?u=rolandomagico

git clone https://github.com/openwrt/openwrt.git -b $OPENWRT_TAG
cd openwrt/

git am < ../$DEVICE_PATCH
git am < 0002-mediatek-filogic-Cudy-WR3000H-Fix-SUPPORTED_DEVICES.patch
git am < 0003-mediatek-filogic-fix-2.5G-phy-compatible-for-WR3000H.patch
git am < 0004-mediatek-Create-common-DTSI-for-WR3000H-and-WR3000S.patch

./scripts/feeds update -a && ./scripts/feeds install -a

wget -O .config $CONFIG_BUILDINFO

make defconfig

# The following command will probably fail, can be ignored. vermagic should be present afterwards anyway
make target/linux/{clean,compile}

# The following command should print the vermagic "6ace983a14b769f576fe9c4c7961bd89"
find build_dir/ -name .vermagic -exec cat {} \;
read -p "Press enter to continue"

make download
make -j$(nproc)

cp bin/*/*/$ARTIFACTS ../output
