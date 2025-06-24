#!/bin/bash
# Configuration section
OPENWRT_TAG=v24.10.2
DEVICE_PATCH=0001-ipq40xx-Add-support-for-Linksys-MR6350.patch
CONFIG_BUILDINFO=https://downloads.openwrt.org/releases/24.10.2/targets/ipq40xx/generic/config.buildinfo

# Create directory for storing the build result
mkdir output

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

# The following command should print the vermagic "eaef302ef5ab82928154706763925f63"
find build_dir/ -name .vermagic -exec cat {} \;
read -p "Press enter to continue"

make download
make -j$(nproc)

find bin/ -iname "*MR6350*" -exec cp '{}' ../output/ \;
find bin/ -iname "*.buildinfo" -exec cp '{}' ../output/ \;
find bin/ -iname "profiles.json" -exec cp '{}' ../output/ \;
find bin/ -iname "sha256sums" -exec cp '{}' ../output/ \;
