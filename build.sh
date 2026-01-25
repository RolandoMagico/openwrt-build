#!/bin/bash
set -e

# Disable SSL certificate verification (for corporate proxies)
export GIT_SSL_NO_VERIFY=1

# Configuration section
OPENWRT_TAG=v24.10.5
# NOTE: The initramfs recovery patch is no longer needed - it was merged upstream in v24.10.5!
# We only need the ubootmod patch for the merged partition layout.
DEVICE_PATCH=0001-mediatek-filogic-D-Link-M30-add-ubootmod-variant.patch
CONFIG_BUILDINFO=https://mirror-03.infra.openwrt.org/releases/24.10.5/targets/mediatek/filogic/config.buildinfo
ARTIFACTS="*aquila-pro-ai-m30*"

# Create directory for storing the build result
mkdir -p output

# The following steps are based on the following information
# - https://hamy.io/post/0015/how-to-compile-openwrt-and-still-use-the-official-repository/
# - https://forum.openwrt.org/t/from-snapshot-to-stable-release-22-03/136038/18?u=rolandomagico

# Clone OpenWrt if not already present (supports caching)
if [ ! -d "openwrt/.git" ]; then
    rm -rf openwrt
    git clone https://github.com/openwrt/openwrt.git -b "$OPENWRT_TAG"
fi

cd openwrt/ || exit 1

# Configure git user for applying patches
git config user.email "build@local"
git config user.name "Build"

# Reset to clean state and apply patch (in case of cached/partial state)
git reset --hard "origin/$OPENWRT_TAG" 2>/dev/null || git reset --hard "$OPENWRT_TAG"
git clean -fd

# Apply the ubootmod patch (adds D-Link M30 with merged partitions for extra storage)
git am < "../$DEVICE_PATCH"

./scripts/feeds update -a && ./scripts/feeds install -a

wget --no-check-certificate -O .config "$CONFIG_BUILDINFO"

make defconfig

# The following command will probably fail, can be ignored. vermagic should be present afterwards anyway
make target/linux/{clean,compile} || true

# The following command should print the vermagic
VERMAGIC=$(find build_dir/ -name .vermagic -exec cat {} \; 2>/dev/null || echo "not found")
echo "Vermagic: $VERMAGIC"

make download DOWNLOAD_CHECK_CERTIFICATE=
make -j"$(nproc)"

cp bin/targets/*/*/$ARTIFACTS ../output/
