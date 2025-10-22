#!/bin/bash
# Configuration section
OPENWRT_VERSION=24.10.4
OPENWRT_TAG=v$OPENWRT_VERSION
DEVICE_PATCH=0001-ipq40xx-Add-support-for-Linksys-MR6350.patch
CONFIG_BUILDINFO=https://downloads.openwrt.org/releases/$OPENWRT_VERSION/targets/ipq40xx/generic/config.buildinfo
EXPECTED_VERMAGIC=eaef302ef5ab82928154706763925f63
TARGET_PROFILE=linksys_mr6350
OUTPUT_DIR=output

# Create directory for storing the build result
mkdir $OUTPUT_DIR

# The following steps are based on the following information
# - https://hamy.io/post/0015/how-to-compile-openwrt-and-still-use-the-official-repository/
# - https://forum.openwrt.org/t/from-snapshot-to-stable-release-22-03/136038/18?u=rolandomagico

git clone https://github.com/openwrt/openwrt.git -b $OPENWRT_TAG
cd openwrt/

git config --global user.email "nobody@home.com"
git config --global user.name "Hans Wurscht"

git am < ../$DEVICE_PATCH

./scripts/feeds update -a && ./scripts/feeds install -a

wget -O .config $CONFIG_BUILDINFO

make defconfig

# The following command will probably fail, can be ignored. vermagic should be present afterwards anyway
make target/linux/{clean,compile}

# The following command should print the vermagic "3abe85def815b59c6c75ac1f92135cb6"
CURRENT_VERMAGIC=$(find build_dir/ -name .vermagic -exec cat {} \;)
if [ "$CURRENT_VERMAGIC" == "$EXPECTED_VERMAGIC" ]; then
    echo "Found expected vermagic $EXPECTED_VERMAGIC"
else
    echo "Current vermagic $CURRENT_VERMAGIC differs from expected vermagic $EXPECTED_VERMAGIC"
    exit 1
fi

make download
make -j$(nproc)

rsync -avm --include="config.buildinfo" \
           --include="feeds.buildinfo" \
           --include="profiles.json" \
           --include="sha256sums" \
           --include="version.buildinfo" \
           --include="*$TARGET_PROFILE*" \
           --exclude="*" bin/targets/*/*/ ../$OUTPUT_DIR
